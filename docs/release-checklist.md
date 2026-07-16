# Release Checklist

Use this before creating a GitHub release.

## Build

- [ ] Run `hugo --source example-site --themesDir ../.. --theme termfolio`.
- [ ] Confirm the example site renders the home, posts, projects, taxonomies, and search pages.
- [ ] Confirm `git diff --check` passes.

## Documentation

- [ ] Update `CHANGELOG.md`.
- [ ] Update `README.md` if installation, configuration, screenshots, or behavior changed.
- [ ] Verify README images render in GitHub's README view.
- [ ] Verify `theme.toml` and `hugo.toml` match the supported Hugo version.

## Media

- [ ] Regenerate `static/images/termfolio-example.gif` if the UI changed.
- [ ] Regenerate `static/images/screenshots/home.png` if the home page changed.
- [ ] Regenerate `static/images/screenshots/post.png` if post rendering changed.
- [ ] Regenerate `static/images/screenshots/projects.png` if project rendering changed.
- [ ] Regenerate `static/images/screenshots/search.png` if search rendering changed.
- [ ] Regenerate `images/screenshot.png` and `images/tn.png` if the gallery preview changed.

## GitHub Release

- [ ] Create a semver tag such as `v0.1.0`.
- [ ] Attach or link the GIF and screenshot assets in the release notes when useful.
- [ ] Confirm the generated release notes mention breaking changes, new features, and documentation updates.

## Hugo Themes

- [ ] If gallery assets or metadata changed, create a new release tag so the Hugo Themes builder can pick them up.
- [ ] If this is the first public release, submit the theme to `gohugoio/hugoThemesSiteBuilder`.
