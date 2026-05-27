#!/usr/bin/env bash
set -euo pipefail

failures=0

assert_file() {
  local path="$1"
  if [[ ! -f "$path" ]]; then
    printf 'missing file: %s\n' "$path" >&2
    failures=$((failures + 1))
  fi
}

assert_contains() {
  local path="$1"
  local needle="$2"
  if [[ ! -f "$path" ]]; then
    printf 'cannot inspect missing file: %s\n' "$path" >&2
    failures=$((failures + 1))
    return
  fi
  if ! grep -Fq "$needle" "$path"; then
    printf 'missing content in %s: %s\n' "$path" "$needle" >&2
    failures=$((failures + 1))
  fi
}

assert_file "_layouts/index.html"
assert_file "static/styles.css"
assert_file "js/main.js"
assert_file "js/scroll.js"
assert_file "files/jumbotron.css"
assert_file "other-publications.html"
assert_file "img/logo/ORNL.png"

assert_contains "_config.yml" "title: Chenrui Ma"
assert_contains "_config.yml" "theme: minima"
assert_contains "_config.yml" "tests/"
assert_contains "index.md" "layout: index"

assert_contains "_layouts/index.html" "navbar-custom"
assert_contains "_layouts/index.html" "intro-panel"
assert_contains "_layouts/index.html" "Chenrui Ma"
assert_contains "_layouts/index.html" "University of Virginia"
assert_contains "_layouts/index.html" "merry7cherry"
assert_contains "_layouts/index.html" "Learning Straight Flows"
assert_contains "_layouts/index.html" "Beyond Editing Pairs"
assert_contains "_layouts/index.html" "Professional Services"
assert_contains "_layouts/index.html" "2026FALL_PHD_CV.pdf"
assert_contains "_layouts/index.html" "cv-logo"
assert_contains "_layouts/index.html" "Oak Ridge National Laboratory logo"
assert_contains "_layouts/index.html" "CVPR'26"
assert_contains "_layouts/index.html" "AAAI'26"
assert_contains "_layouts/index.html" "ACL'26"
assert_contains "_layouts/index.html" "ICASSP'26"
assert_contains "_layouts/index.html" "WACV'26"

if grep -Fq '<span class="email-link">Irvine, California, USA</span>' "_layouts/index.html"; then
  printf 'removed location still present in _layouts/index.html\n' >&2
  failures=$((failures + 1))
fi

if grep -Fq 'My research focuses on' "_layouts/index.html"; then
  printf 'research interest still contains explanatory paragraph\n' >&2
  failures=$((failures + 1))
fi

assert_contains "static/styles.css" ".navbar-custom"
assert_contains "static/styles.css" ".pub-card"
assert_contains "static/styles.css" ".cv-entry"
assert_contains "static/styles.css" ".cv-logo"
assert_contains "static/styles.css" "grid-template-columns: 165px 82px 1fr;"
assert_contains "static/styles.css" "height: 76px;"
assert_contains "other-publications.html" "CTR-LoRA"
assert_contains "other-publications.html" "CIBR"

date_line=$(grep -n -m 1 'class="cv-entry-date"' "_layouts/index.html" | cut -d: -f1 || true)
logo_line=$(grep -n -m 1 'class="cv-logo-wrap"' "_layouts/index.html" | cut -d: -f1 || true)
if [[ -z "$date_line" || -z "$logo_line" || "$date_line" -gt "$logo_line" ]]; then
  printf 'cv entry order must be date, logo, body\n' >&2
  failures=$((failures + 1))
fi

if [[ "$failures" -gt 0 ]]; then
  printf 'site migration check failed with %s issue(s)\n' "$failures" >&2
  exit 1
fi

printf 'site migration check passed\n'
