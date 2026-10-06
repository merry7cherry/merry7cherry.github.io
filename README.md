# Chenrui Ma's Personal Website

Source for Chenrui Ma's academic homepage.

The site is built with Jekyll/GitHub Pages and has been migrated to the layout
style of [`xixiaouab/xixiaouab.github.io`](https://github.com/xixiaouab/xixiaouab.github.io).
Homepage content, publications, links, images, and CV assets are maintained in
this repository.

## Content Sources

- Homepage profile, news, experience, education, awards, and services live in
  `_layouts/index.html`.
- Shared page metadata, navigation, footer, and script dependencies live in
  `_includes/site-head.html`, `_includes/site-navbar.html`,
  `_includes/site-footer.html`, and `_includes/site-scripts.html`.
- `_data/publications.yml` is the single source for both selected publications
  and the complete publication archive. It also stores reviewed Semantic
  Scholar paper IDs and GitHub repository names for publication metrics.
- `_data/publication_metrics.yml` stores generated citation and Star counts;
  `scripts/update_publication_metrics.rb` validates and refreshes that data.
- Publication cards use optimized AVIF files under `img/papers/thumbs/`; their
  full-resolution PNG files are loaded only when the lightbox opens.
- Citation counts are sourced from Semantic Scholar and Star counts from the
  GitHub repository API. The homepage and publication archive render the same
  checked data and show its UTC freshness date.

## Local Checks

```bash
bash tests/site_migration_check.sh
```

The metrics data can be validated without network access:

```bash
ruby scripts/update_publication_metrics.rb --check
```

## Publication Metrics Refresh

The weekly `Update publication metrics` workflow runs from the default branch,
checks out `codex/development`, refreshes the metrics, runs the site checks, and
opens or updates a PR into `codex/development`. It never writes directly to the
production `master` branch.

The `Validate site` workflow runs the same repository checks on pull requests
targeting `codex/development` or `master`, so review pages show an explicit
validation result.

Add the Semantic Scholar key as the repository Actions secret
`SEMANTIC_SCHOLAR_API_KEY`. GitHub Stars use the workflow's built-in
`GITHUB_TOKEN`; no separate GitHub API key is needed. Until the Semantic Scholar
secret is configured, scheduled runs exit successfully with a warning and do
not alter the checked-in metrics.

The checked-in `Gemfile`/`Gemfile.lock` mirror the template's GitHub Pages
tooling. On machines with Ruby 2.7 or newer, use:

```bash
bundle install
bundle exec jekyll serve
```

## Release Workflow

Develop and review changes on `codex/development`. After the checks and browser
review pass, fast-forward `master` to the reviewed commit and push `master` as
the GitHub Pages source. Verify the completed Pages run and read the live page
back before considering the release complete.

## Current Content Decisions

As of October 5, 2026, Posterior Flow Matching is first in Selected Publications
and the 2026 publication archive, with the remaining selected papers in their
existing relative order. Its seven authors follow the public preprint, and its
thumbnail variants reuse the project page's application overview (`assets/teaser.webp`).
Page links to `https://merry7cherry.github.io/posterior-flow-matching/`, Paper to
`https://merry7cherry.github.io/posterior-flow-matching/assets/paper.pdf`, and Code
to `https://github.com/merry7cherry/posterior-flow-matching`; all three returned
HTTP 200 when checked on October 5, 2026. The displayed status is
"arXiv preprint, 2026 — link forthcoming". The author reports that arXiv is on
hold; no public arXiv identifier is recorded. Once that URL is available, update
PFM's `paper_url` and both venue labels in `_data/publications.yml`. No citation
or Star count is asserted for this new entry. The archive now has 14 records.

As of October 5, 2026, Drift Flow Matching links appear in Page, Paper, Code
order on both the homepage and publication archive. The Page links to
`https://merry7cherry.github.io/drift-flow-matching/`, Paper to
`https://arxiv.org/abs/2605.17244`, and Code to
`https://github.com/merry7cherry/drift-flow-matching`. Publication templates
render Page only when a record provides `page_url`.

The September 24, 2026 update highlights Summer 2027 research internships in
Generative AI. Before the October 5 PFM addition, Selected Publications contained DFM, Stochastic Interpolants,
Learning Straight Flows, CAD-VAE, StructLoRA, D-HSM, and TFM, in that order.
DFM and Stochastic Interpolants were confirmed as NeurIPS 2026 Main Track
posters by the September 24 decision emails. TFM remains labeled arXiv until
a formal acceptance is confirmed. ICLR 2027 reviewer service was confirmed by
the September 23 reviewer bidding email. All 13 publication records from that update remain
in the complete archive; PROBE is no longer selected.
The NeurIPS news item uses "Two of our works". Selected publication venue
labels use dark red, while one-sentence summaries use the primary navy color.
This color treatment was approved for GitHub release on September 24, 2026.

Research cards are Efficient Generative Modeling, Trustworthy Machine Learning,
and Multimodal AI. Each card shows its heading and paper links, without a
separate descriptive sentence. The generative modeling card includes TFM with an arXiv 2026
label alongside the two NeurIPS papers and Learning Straight Flows.

Homepage order is About, Research Interests, News, Selected Publications,
Experience/Education, Awards, and Service. Local source updates do not imply
a production deployment; follow the release verification steps above.

The linked `files/2026FALL_PHD_CV.pdf` was inspected during this update and
still lists Stochastic Interpolants as submitted to ICLR. The PDF needs a
separate CV-source update to match the website's confirmed publication status.

The seven selected publication summaries were reviewed against their linked
papers and revised to state the main mechanism and practical benefit in one
sentence. They distinguish DFM's iterative refinement, TFM's direct transitions,
S-VFM's trajectory straightness, and conditional coupling for pixel-space
generation; the remaining summaries explain correlation modeling, cross-layer
LoRA coordination, and textual memory with recent video frames.
