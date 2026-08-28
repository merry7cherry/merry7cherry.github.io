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
