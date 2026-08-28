#!/usr/bin/env bash
set -euo pipefail

failures=0

fail() {
  printf '%s\n' "$1" >&2
  failures=$((failures + 1))
}

assert_file() {
  [[ -f "$1" ]] || fail "missing required file: $1"
}

assert_absent() {
  [[ ! -e "$1" ]] || fail "obsolete file still present: $1"
}

assert_contains() {
  local file=$1
  local needle=$2
  grep -Fq "$needle" "$file" || fail "missing expected content in $file: $needle"
}

assert_not_contains() {
  local file=$1
  local needle=$2
  if grep -Fq "$needle" "$file"; then
    fail "forbidden content still present in $file: $needle"
  fi
}

required_files=(
  "_config.yml"
  "_data/publications.yml"
  "_layouts/index.html"
  "other-publications.html"
  "static/styles.css"
  "js/main.js"
  "img/ChenruiMa.jpeg"
)
for file in "${required_files[@]}"; do
  assert_file "$file"
done

obsolete_files=(
  ".github/workflows/update-metrics.yml"
  "publications.json"
  "fetch_metrics.py"
  "update_metrics.py"
  "js/scroll.js"
  "CACHE_USAGE.md"
  "CHANGES.md"
  "CLEANUP_GUIDE.md"
  "FINAL_IMPLEMENTATION.md"
  "FINAL_SUMMARY.md"
  "FONT_UPDATE_SUMMARY.md"
  "IMAGE_SIZE_UPDATE.md"
  "LINKS_UPDATE_SUMMARY.md"
  "METRICS_FEATURE.md"
  "METRICS_SETUP_GUIDE.md"
  "SHIELDS_IO_SOLUTION.md"
  "USAGE_GUIDE.md"
)
for file in "${obsolete_files[@]}"; do
  assert_absent "$file"
done

assert_contains "_layouts/index.html" 'class="skip-link"'
assert_contains "_layouts/index.html" '<main id="main-content" tabindex="-1">'
assert_contains "_layouts/index.html" '>Research</a>'
assert_contains "_layouts/index.html" '>News</a>'
assert_contains "_layouts/index.html" 'class="nav-dropdown-toggle dropdown-toggle"'
assert_contains "_layouts/index.html" 'site.data.publications'
assert_contains "_layouts/index.html" 'data-full-src="{{ paper.image.full | relative_url }}"'
assert_contains "_layouts/index.html" 'loading="lazy"'
assert_contains "_layouts/index.html" 'decoding="async"'
assert_contains "_layouts/index.html" 'srcset="{{ paper.image.thumb | relative_url }} 480w, {{ paper.image.thumb_2x | relative_url }} 960w"'
assert_contains "_layouts/index.html" 'aria-label="Paper: {{ paper.title | escape }}"'
assert_contains "_layouts/index.html" 'static/styles.css?v=20260827-2'
assert_contains "_layouts/index.html" 'js/main.js?v=20260827-2'
assert_contains "_layouts/index.html" 'Not All Directions Matter: Towards Structured and Task-Aware Low-Rank Model Adaptation'
assert_contains "_layouts/index.html" 'EMNLP 2026 Findings'
assert_contains "_layouts/index.html" '08/2026 - Present'
assert_contains "_layouts/index.html" '05/2025 - Present'
assert_not_contains "_layouts/index.html" 'Toward Structured and Task-Aware Low-Rank Adaptation'
assert_not_contains "_layouts/index.html" '<font'
assert_not_contains "_layouts/index.html" 'toggle_vis('
assert_not_contains "_layouts/index.html" 'showPubs('
assert_not_contains "_layouts/index.html" 'SmoothScroll'
assert_not_contains "_layouts/index.html" 'padding-top: 70px; margin-top: -80px;'

assert_contains "other-publications.html" 'layout: null'
assert_contains "other-publications.html" 'Complete publication list grouped by year.'
assert_contains "other-publications.html" 'site.data.publications'
assert_contains "other-publications.html" 'sort: "sort_key" | reverse'
assert_contains "other-publications.html" 'aria-current="page"'
assert_contains "other-publications.html" '<main id="main-content" tabindex="-1">'
assert_contains "other-publications.html" 'static/styles.css?v=20260827-2'
assert_contains "other-publications.html" 'js/main.js?v=20260827-2'
assert_not_contains "other-publications.html" 'Additional papers grouped by year'
assert_not_contains "other-publications.html" '<center>'

assert_contains "js/main.js" 'thumbnail.getAttribute("data-full-src")'
assert_contains "js/main.js" 'siteShell.setAttribute("inert", "")'
assert_contains "js/main.js" 'siteShell.removeAttribute("inert")'
assert_contains "js/main.js" '.nav-link, .dropdown-item'
assert_contains "js/main.js" '.nav-dropdown-toggle'
assert_contains "js/main.js" 'event.target === dialog'
assert_contains "js/main.js" 'event.key === "Escape"'
assert_contains "js/main.js" 'event.key === "Tab"'
assert_contains "js/main.js" 'triggerToRestore.focus()'
assert_not_contains "js/main.js" 'function showPubs'

assert_contains "static/styles.css" 'scroll-behavior: smooth;'
assert_contains "static/styles.css" 'scroll-margin-top: 92px;'
assert_contains "static/styles.css" '.skip-link'
assert_contains "static/styles.css" '.nav-split-control'
assert_contains "static/styles.css" '.nav-dropdown-toggle'
assert_contains "static/styles.css" '.pub-title'
assert_contains "static/styles.css" '.pub-summary'
assert_contains "static/styles.css" '.publication-lightbox[hidden]'
assert_contains "static/styles.css" '@media (prefers-reduced-motion: reduce)'
assert_not_contains "static/styles.css" 'scroll-padding-top:'

ruby <<'RUBY' || failures=$((failures + 1))
require "yaml"

papers = YAML.safe_load(File.read("_data/publications.yml"))
raise "publication data must be a non-empty array" unless papers.is_a?(Array) && !papers.empty?
raise "expected 13 publications, found #{papers.length}" unless papers.length == 13

ids = papers.map { |paper| paper.fetch("id") }
raise "publication ids must be unique" unless ids.uniq.length == ids.length

selected = papers.select { |paper| paper["selected"] }.sort_by { |paper| paper.fetch("selected_order") }
expected_selected = %w[
  drift-flow-matching
  transition-flow-matching
  learning-straight-flows
  cad-vae
  stochastic-interpolants
  not-all-directions
  dhsm
  probe
]
raise "selected publication order changed: #{selected.map { |paper| paper["id"] }}" unless selected.map { |paper| paper["id"] } == expected_selected

not_all = papers.find { |paper| paper["id"] == "not-all-directions" }
expected_acl_title = "Not All Directions Matter: Towards Structured and Task-Aware Low-Rank Model Adaptation"
raise "ACL title is not canonical" unless not_all && not_all["title"] == expected_acl_title

cibr = papers.find { |paper| paper["id"] == "cibr" }
expected_cibr_title = "CIBR: Cross-Modal Information Bottleneck Regularization for Robust CLIP Generalization"
raise "CIBR title is not canonical" unless cibr && cibr["title"] == expected_cibr_title

papers.each do |paper|
  raise "missing sort key for #{paper["id"]}" if paper["sort_key"].to_s.empty?
  raise "missing authors for #{paper["id"]}" unless paper["authors"].is_a?(Array) && !paper["authors"].empty?
  raise "missing paper URL for #{paper["id"]}" if paper["paper_url"].to_s.empty?
  next unless paper["selected"]

  image = paper.fetch("image")
  %w[thumb thumb_2x full width height alt].each do |field|
    raise "missing image #{field} for #{paper["id"]}" if image[field].to_s.empty?
  end
  %w[thumb thumb_2x full].each do |field|
    path = image.fetch(field).sub(%r{\A/}, "")
    raise "missing image file for #{paper["id"]}: #{path}" unless File.file?(path)
  end
end

html = File.read("_layouts/index.html")
experience = html[/<div class="cv-panel" id="Experience">(.*?)<div class="cv-panel" id="Education">/m, 1]
raise "experience section not found" unless experience
experience_dates = experience.scan(/class="cv-entry-date">([^<]+)</).flatten
expected_dates = [
  "08/2026 - Present",
  "05/2025 - Present",
  "01/2026 - 03/2026",
  "09/2024 - 06/2026",
]
raise "current experience entries must precede completed roles: #{experience_dates}" unless experience_dates == expected_dates
RUBY

thumb_count=$(find img/papers/thumbs -type f -name '*.avif' | wc -l | tr -d ' ')
if [[ "$thumb_count" != "16" ]]; then
  fail "expected 16 AVIF thumbnail variants, found $thumb_count"
fi

thumb_bytes=0
while IFS= read -r thumb; do
  size=$(wc -c < "$thumb")
  thumb_bytes=$((thumb_bytes + size))
  if (( size > 102400 )); then
    fail "thumbnail exceeds 100 KiB: $thumb ($size bytes)"
  fi
done < <(find img/papers/thumbs -type f -name '*.avif' -print | sort)
if (( thumb_bytes > 716800 )); then
  fail "combined publication thumbnails exceed 700 KiB: $thumb_bytes bytes"
fi

if command -v file >/dev/null 2>&1; then
  profile_metadata=$(file img/ChenruiMa.jpeg)
  if [[ "$profile_metadata" == *"GPS-Data"* || "$profile_metadata" == *"HUAWEI"* || "$profile_metadata" == *"JEF-AN00"* ]]; then
    fail "profile photo still exposes device or GPS EXIF metadata"
  fi
fi

if [[ "$failures" -gt 0 ]]; then
  printf 'site migration check failed with %s issue(s)\n' "$failures" >&2
  exit 1
fi

printf 'site migration check passed\n'
