# Hugo Themes Submission Checklist

Termfolio is prepared for submission to the Hugo Themes gallery.

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

## Submission Steps

1. Fork `github.com/gohugoio/hugoThemesSiteBuilder`.
2. Add `github.com/joe-mccarthy/termfolio` to `themes.txt` in lexicographical order.
3. Use a commit message like `Add theme termfolio`.
4. Open a pull request.
5. Confirm the Netlify deploy preview succeeds.

## Release Note

The Hugo Themes build may use metadata and images from the latest release. If screenshots, `theme.toml`, or `hugo.toml` change after a release, tag a new release before expecting the gallery to reflect those changes.
