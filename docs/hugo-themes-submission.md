# Hugo Themes Submission Checklist

Termfolio is prepared for submission to the Hugo Themes gallery after the
release candidate passes the checks below and is published as a stable release.

Source requirements were checked against the
[Hugo Themes Site Builder](https://github.com/gohugoio/hugoThemesSiteBuilder)
documentation.

## Repository Files

- [x] `README.md` is descriptive and written in English.
- [x] `theme.toml` exists at the repository root.
- [x] `hugo.toml` exists at the repository root and declares supported Hugo versions.
- [x] `LICENSE` is present and open source.
- [x] `images/screenshot.png` exists.
- [x] `images/tn.png` exists.

## Media Requirements

- [x] `images/screenshot.png` uses a 3:2 aspect ratio.
- [x] `images/screenshot.png` is at least `1500x1000`.
- [x] `images/tn.png` uses a 3:2 aspect ratio.
- [x] `images/tn.png` is at least `900x600`.
- [x] README images use absolute `raw.githubusercontent.com` URLs.
- [x] Additional README media is stored in the repository under `static/images/`.

## Metadata

- [x] `theme.toml` has `name`.
- [x] `theme.toml` has `license`.
- [x] `theme.toml` has `licenselink`.
- [x] `theme.toml` has `description`.
- [x] `theme.toml` has `homepage`.
- [x] `theme.toml` has `demosite`.
- [x] `theme.toml` has `tags`.
- [x] `theme.toml` has `features`.
- [x] `theme.toml` has author metadata.

## Release Validation

- [x] Standard Hugo `0.128.0`, the declared minimum, builds with warnings treated
      as errors.
- [x] Standard Hugo `0.166.0`, the current Hugo Themes builder version, builds
      with warnings treated as errors.
- [x] The complete documentation, shell, release-validator, and accessibility
      checks pass.
- [ ] The live demo is deployed from the exact validated commit.
- [ ] The latest stable release contains `theme.toml`, `hugo.toml`, `README.md`,
      `LICENSE`, `images/screenshot.png`, and `images/tn.png`.

## Submission Steps

1. Fork `github.com/gohugoio/hugoThemesSiteBuilder`.
2. Add `github.com/joe-mccarthy/termfolio` to `themes.txt` between
   `github.com/jnjosh/internet-weblog` and `github.com/joeroe/risotto`.
3. Use a commit message like `Add theme termfolio`.
4. Open a pull request.
5. Confirm the Netlify deploy preview succeeds.

## Release Note

The Hugo Themes build uses metadata and images from the latest stable release
when one exists. Publish and verify a new stable release before submitting
changes to screenshots, `theme.toml`, `hugo.toml`, or README media. Do not move
or delete published tags because the gallery fetches themes with Go modules.
