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
assert_file "img/papers/drift-flow-matching.png"
assert_file "img/papers/transition-flow-matching.png"

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
assert_contains "_layouts/index.html" "Transition Flow Matching"
assert_contains "_layouts/index.html" "Drift Flow Matching"
assert_contains "_layouts/index.html" "img/papers/drift-flow-matching.png"
assert_contains "_layouts/index.html" "img/papers/transition-flow-matching.png"
assert_contains "_layouts/index.html" "Professional Services"
assert_contains "_layouts/index.html" "2026FALL_PHD_CV.pdf"
assert_contains "_layouts/index.html" "cv-logo"
assert_contains "_layouts/index.html" "Oak Ridge National Laboratory logo"
assert_contains "_layouts/index.html" "RAISE Lab @ UVA"
assert_contains "_layouts/index.html" "Charlottesville, Virginia, USA"
assert_contains "_layouts/index.html" "Prof. Ferdinando Fioretto"
assert_contains "_layouts/index.html" "Teaching Service"
assert_contains "_layouts/index.html" "Visitor Map"
assert_contains "_layouts/index.html" "clustrmaps"
assert_contains "_layouts/index.html" "//cdn.clustrmaps.com/map_v2.js"
assert_contains "_layouts/index.html" "d=iI_u2m1shREKH65b-dCj2xTFY9f4fmyojjObbBCeWvQ"
assert_contains "_layouts/index.html" "All Publications"
assert_contains "_layouts/index.html" "View All Publications"
assert_contains "_layouts/index.html" "CVPR'26"
assert_contains "_layouts/index.html" "AAAI'26"
assert_contains "_layouts/index.html" "ACL'26"
assert_contains "_layouts/index.html" "ICASSP'26"
assert_contains "_layouts/index.html" "WACV'26"
assert_contains "_layouts/index.html" "arXiv'26a"
assert_contains "_layouts/index.html" "arXiv'26b"
assert_contains "_layouts/index.html" "Generative Modeling</b>"
assert_contains "_layouts/index.html" "Trustworthy Machine Learning</b>"
assert_contains "_layouts/index.html" "Multimodal AI</b>"
assert_contains "_layouts/index.html" "https://arxiv.org/abs/2511.17583"
assert_contains "_layouts/index.html" "https://arxiv.org/abs/2509.23122"
assert_contains "_layouts/index.html" "https://arxiv.org/abs/2603.15689"
assert_contains "_layouts/index.html" "https://arxiv.org/abs/2605.17244"
assert_contains "_layouts/index.html" "https://arxiv.org/abs/2503.07938"
assert_contains "_layouts/index.html" "https://arxiv.org/abs/2603.14228"
assert_contains "_layouts/index.html" "https://arxiv.org/abs/2510.15962"
assert_contains "_layouts/index.html" "https://arxiv.org/abs/2511.12410"
assert_contains "_layouts/index.html" "https://link.springer.com/chapter/10.1007/978-3-032-04558-4_20"

if grep -Fq '<span class="email-link">Irvine, California, USA</span>' "_layouts/index.html"; then
  printf 'removed location still present in _layouts/index.html\n' >&2
  failures=$((failures + 1))
fi

if grep -Fq 'intro-kicker' "_layouts/index.html"; then
  printf 'intro kicker still present in _layouts/index.html\n' >&2
  failures=$((failures + 1))
fi

if grep -Fq 'Other Publications' "_layouts/index.html"; then
  printf 'homepage still uses Other Publications wording\n' >&2
  failures=$((failures + 1))
fi

if grep -Fq 'drift-flow-matching.svg' "_layouts/index.html" "publications.json"; then
  printf 'DFM publication image still points to old SVG\n' >&2
  failures=$((failures + 1))
fi

if grep -Fq 'transition-flow-matching.svg' "_layouts/index.html" "publications.json"; then
  printf 'TFM publication image still points to old SVG\n' >&2
  failures=$((failures + 1))
fi

if grep -Fq 'My research focuses on' "_layouts/index.html"; then
  printf 'research interest still contains explanatory paragraph\n' >&2
  failures=$((failures + 1))
fi

python3 - <<'PY' || failures=$((failures + 1))
from pathlib import Path

html = Path("_layouts/index.html").read_text()
start = html.index('<h3 id="Research"')
end = html.index('<h3 id="News"')
section = html[start:end]

required = [
    "Generative Modeling</b>",
    "Trustworthy Machine Learning</b>",
    "Multimodal AI</b>",
    "CVPR'26",
    "arXiv'25",
    "arXiv'26a",
    "arXiv'26b",
    "https://arxiv.org/abs/2511.17583",
    "https://arxiv.org/abs/2509.23122",
    "https://arxiv.org/abs/2603.15689",
    "https://arxiv.org/abs/2605.17244",
    "https://arxiv.org/abs/2503.07938",
    "https://arxiv.org/abs/2603.14228",
    "https://arxiv.org/abs/2510.15962",
    "https://arxiv.org/abs/2511.12410",
    "https://link.springer.com/chapter/10.1007/978-3-032-04558-4_20",
]
for needle in required:
    if needle not in section:
        raise SystemExit(f"missing research interest content: {needle}")

for forbidden in [
    "Generative Modeling &amp; Efficient Generation",
    "Efficient Model Adaptation &amp; Language Models",
    "Multi-modal Perception &amp; Trustworthy Representation Learning",
    "https://cvpr.thecvf.com/",
    "https://aaai.org/conference/aaai/aaai-26/",
    "https://icml.cc/",
    "https://2026.aclweb.org/",
    "https://2026.ieeeicassp.org/",
    "https://wacv.thecvf.com/virtual/2026",
    "https://e-nns.org/icann2025/",
    "arXiv'26: TFM",
    "arXiv'26: DFM",
]:
    if forbidden in section:
        raise SystemExit(f"forbidden research interest content: {forbidden}")
PY

python3 - <<'PY' || failures=$((failures + 1))
from pathlib import Path

html = Path("_layouts/index.html").read_text()
start = html.index('<div id="pubs_selected"')
end = html.index('<div class="publication-more-link">', start)
section = html[start:end]

required = [
    "Transition Flow Matching",
    "https://arxiv.org/abs/2603.15689",
    "Drift Flow Matching",
    "https://arxiv.org/abs/2605.17244",
    "Stochastic Interpolants via Conditional Dependent Coupling",
    ">arXiv</",
    "Xi Xiao*, <strong><u>Chenrui Ma*</u></strong>, Yunbei Zhang*",
]
for needle in required:
    if needle not in section:
        raise SystemExit(f"missing selected publication content: {needle}")

for forbidden in [
    "Beyond Editing Pairs",
    "ICML 2026 Submitted",
    "https://icml.cc/",
]:
    if forbidden in section:
        raise SystemExit(f"forbidden selected publication content: {forbidden}")
PY

if grep -Fq 'Student Collaborator (remote)' "_layouts/index.html"; then
  printf 'student collaborator still includes remote in role\n' >&2
  failures=$((failures + 1))
fi

if grep -Fq 'Conference reviewer for CVPR 2026 and AAAI 2026. Teaching Assistant' "_layouts/index.html"; then
  printf 'teaching assistant still bundled into academic service\n' >&2
  failures=$((failures + 1))
fi

assert_contains "static/styles.css" ".navbar-custom"
assert_contains "static/styles.css" ".pub-card"
assert_contains "static/styles.css" ".cv-entry"
assert_contains "static/styles.css" ".cv-logo"
assert_contains "static/styles.css" ".visitor-map"
assert_contains "static/styles.css" "grid-template-columns: 165px 82px 1fr;"
assert_contains "static/styles.css" "height: 76px;"
assert_contains "other-publications.html" "CTR-LoRA"
assert_contains "other-publications.html" "CIBR"
assert_contains "other-publications.html" "<title>All Publications | Chenrui Ma</title>"
assert_contains "other-publications.html" ">All Publications</a>"
assert_contains "other-publications.html" "<h1>All Publications</h1>"
assert_contains "other-publications.html" "Additional papers grouped by year. For selected works, return to the <a href=\"index.html#Publications\">homepage publications section</a>."
assert_contains "other-publications.html" "Transition Flow Matching"
assert_contains "other-publications.html" "Drift Flow Matching"
assert_contains "other-publications.html" "Learning Straight Flows"
assert_contains "other-publications.html" "CAD-VAE"
assert_contains "other-publications.html" "Stochastic Interpolants"
assert_contains "other-publications.html" "Beyond Editing Pairs"
assert_contains "other-publications.html" "Not All Directions Matter"
assert_contains "other-publications.html" "Self-Supervised Visual Prompting"
assert_contains "other-publications.html" "SCS-YOLO"
assert_contains "other-publications.html" "Dense Object Detection Based on De-Homogenized Queries"
assert_contains "other-publications.html" "https://arxiv.org/abs/2603.15689"
assert_contains "other-publications.html" "https://arxiv.org/abs/2605.17244"
assert_contains "other-publications.html" "Xi Xiao*, <strong><u>Chenrui Ma*</u></strong>, Yunbei Zhang*"
assert_contains "publications.json" "\"image\": \"img/papers/drift-flow-matching.png\""
assert_contains "publications.json" "\"image\": \"img/papers/transition-flow-matching.png\""

if grep -Fq 'Other Publications' "other-publications.html"; then
  printf 'archive page still uses Other Publications wording\n' >&2
  failures=$((failures + 1))
fi

if grep -Fq 'Full publication archive, including selected publications from the homepage.' "other-publications.html"; then
  printf 'archive page still uses non-template archive subtitle\n' >&2
  failures=$((failures + 1))
fi

python3 - <<'PY' || failures=$((failures + 1))
from pathlib import Path

html = Path("other-publications.html").read_text()
for title in [
    "Transition Flow Matching",
    "Drift Flow Matching",
    "CAD-VAE: Leveraging Correlation-Aware Latents for Comprehensive Fair Disentanglement",
    "Stochastic Interpolants via Conditional Dependent Coupling",
    "Learning Straight Flows: Variational Flow Matching for Efficient Generation",
    "Not All Directions Matter: Toward Structured and Task-Aware Low-Rank Adaptation",
    "Self-Supervised Visual Prompting for Cross-Domain Road Damage Detection",
    "Beyond Editing Pairs: Fine-Grained Instructional Image Editing via Multi-Scale Learnable Regions",
    "CTR-LoRA: Curvature-Aware and Trust-Region Guided Low-Rank Adaptation for Large Language Models",
    "CIBR: Cross-modal information bottleneck regularization for robust clip generalization",
    "SCS-YOLO: a defect detection model for cigarette appearance",
    "Dense Object Detection Based on De-Homogenized Queries",
]:
    if html.count(title) != 1:
        raise SystemExit(f"expected exactly one archive entry for {title!r}, found {html.count(title)}")
PY

python3 - <<'PY' || failures=$((failures + 1))
import json
from pathlib import Path

data = json.loads(Path("publications.json").read_text())
paper = next((p for p in data["publications"] if p["id"] == "not-all-directions"), None)
if paper is None:
    raise SystemExit("missing not-all-directions publication data")
if paper["authors"][:3] != ["Xi Xiao*", "Chenrui Ma*", "Yunbei Zhang*"]:
    raise SystemExit(f"ACL co-first authors not marked correctly: {paper['authors'][:3]}")
PY

python3 - <<'PY' || failures=$((failures + 1))
import re
from pathlib import Path

html = Path("_layouts/index.html").read_text()
start = html.index('<div class="cv-panel" id="Experience">')
end = html.index('<div class="cv-panel" id="Education">', start)
section = html[start:end]
dates = re.findall(r'class="cv-entry-date">([^<]+)</div>', section)
expected = [
    "08/2026 - Present",
    "01/2026 - 03/2026",
    "05/2025 - Present",
    "09/2024 - Present",
]
if dates != expected:
    raise SystemExit(f"experience entries not sorted by descending start date: {dates}")
PY

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
