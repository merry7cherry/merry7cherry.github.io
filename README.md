# Chenrui Ma's Personal Website

Source for Chenrui Ma's academic homepage.

The site is built with Jekyll/GitHub Pages and has been migrated to the layout
style of [`xixiaouab/xixiaouab.github.io`](https://github.com/xixiaouab/xixiaouab.github.io).
Homepage content, publications, links, images, and CV assets are maintained in
this repository.

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
