# Chenrui Ma's Personal Website

Source for Chenrui Ma's academic homepage.

The site is built with Jekyll/GitHub Pages and has been migrated to the layout
style of [`xixiaouab/xixiaouab.github.io`](https://github.com/xixiaouab/xixiaouab.github.io).
Homepage content, publications, links, images, and CV assets are maintained in
this repository.

## Content Sources

- Homepage profile, news, experience, education, awards, and services live in
  `_layouts/index.html`.
- `_data/publications.yml` is the single source for both selected publications
  and the complete publication archive.
- Publication cards use optimized AVIF files under `img/papers/thumbs/`; their
  full-resolution PNG files are loaded only when the lightbox opens.
- Citation counts and GitHub stars are intentionally not displayed because
  those values are volatile and were not backed by a reliable update pipeline.

## Local Checks

```bash
bash tests/site_migration_check.sh
```

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
