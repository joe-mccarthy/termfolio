# Development

This guide covers local theme development and repository validation. Site authors looking for theme options should start with [Configuration](configuration.md) and [Content](content.md).

## Prerequisites

- Git.
- Standard Hugo `0.128.0` or newer; Hugo Extended is not required.
- Node.js and npm versions declared by [.node-version](../.node-version) and [package.json](../package.json) when running documentation or accessibility checks.
- ShellCheck when validating shell scripts locally.

## Run the example site

From a clone of this repository:

```bash
git clone https://github.com/joe-mccarthy/termfolio
cd termfolio
hugo server --source example-site --themesDir ../.. --theme termfolio
```

Open [http://localhost:1313/termfolio/](http://localhost:1313/termfolio/). Hugo's live reload reflects template, stylesheet, configuration, and content changes.

Build the same site without starting a server:

```bash
hugo --source example-site --themesDir ../.. --theme termfolio
```

To use the example as a starter site rather than a development fixture:

```bash
git clone https://github.com/joe-mccarthy/termfolio termfolio-theme
cp -R termfolio-theme/example-site mysite
cd mysite
git init
mkdir -p themes
cp -R ../termfolio-theme themes/termfolio
perl -0pi -e 's/theme: \.\.\/\./theme: termfolio/' config.yaml
hugo server
```

The copy is then your site. Review its URLs, identity, licence, sample content, menu, and social metadata before publishing.

## Repository structure

```text
termfolio/
├── .github/            # Issue forms, pull-request template, and CI workflows
├── archetypes/         # Templates for new content
├── docs/               # User and maintainer documentation
├── example-site/       # Demo site and regression content
├── images/             # Hugo Themes gallery screenshot and thumbnail
├── layouts/            # Hugo templates, section layouts, and partials
├── scripts/            # Local and CI validation scripts
├── static/             # CSS, fonts, icons, screenshots, and walkthrough media
├── hugo.toml           # Supported Hugo version metadata
└── theme.toml          # Hugo Themes gallery metadata
```

The example site is both documentation and the primary rendering fixture. Add representative content when a layout change needs regression coverage.

## Local checks

Run the theme smoke test with the Hugo version currently on your path:

```bash
bash scripts/test-theme.sh
```

It builds into a temporary directory with warnings treated as errors, verifies key routes, and checks that category, tag, and series term layouts render correctly. Pass an expected version to guard the local toolchain:

```bash
bash scripts/test-theme.sh 0.164.0
```

Install the pinned documentation tooling and run Markdown lint plus link checks:

```bash
npm ci
npm run check
```

Run the remaining release-relevant checks:

```bash
shellcheck scripts/*.sh
bash scripts/test-release-validator.sh
git diff --check
```

The accessibility test expects a production fixture at `.public/`:

```bash
hugo \
  --source example-site \
  --themesDir ../.. \
  --theme termfolio \
  --destination "$PWD/.public" \
  --cleanDestinationDir \
  --gc \
  --minify \
  --noBuildLock \
  --panicOnWarning
npm run test:accessibility
```

The browser audit requires Chrome or Chromium and checks the home, posts, projects, and search routes.

## Quality and compatibility

Continuous integration runs two standard Hugo builds:

- Hugo `0.128.0`, the declared minimum.
- Hugo `0.164.0`, the upper tested version.

The `Required checks` job succeeds only when the complete build matrix and the documentation/accessibility job pass. The quality job runs Markdown lint, documentation link checks, ShellCheck, release-validator tests, and Lighthouse accessibility audits with a minimum score of `0.95` on every audited route.

The current local example baseline recorded during release preparation is:

| Check | Result |
| --- | --- |
| Hugo render | 73 pages with warnings treated as errors on the tested standard Hugo versions. |
| Lighthouse accessibility | Home `1.00`, posts `0.98`, projects `0.95`, search `1.00`. |
| External JavaScript files | `0` on the default example path. |
| Theme CSS | Approximately `14.7 KB`. |
| Home page HTML | Approximately `16.0 KB`. |
| Bundled fonts | Approximately `392 KB`. |
| Full example output | Approximately `4.3 MB`, including screenshots and walkthrough media. |

Treat these sizes as a comparison point, not a guarantee for downstream sites. Content, custom assets, search provider, Hugo version, and minification affect the final output.

## Continuous integration

[.github/workflows/render-example-test.yml](../.github/workflows/render-example-test.yml) is the required pull-request and `main`-branch validation workflow. When changing supported Hugo versions, keep the following in agreement:

- The workflow matrix.
- [hugo.toml](../hugo.toml).
- [theme.toml](../theme.toml).
- The README and this guide.
- Release notes and changelog when the compatibility contract changes.

Do not infer compatibility from a single successful local build. Validate both ends of the supported range with standard Hugo.

## Media updates

Update README and demonstration media after user-visible layout changes:

- `static/images/termfolio-example.gif`
- `static/images/screenshots/home.png`
- `static/images/screenshots/post.png`
- `static/images/screenshots/projects.png`
- `static/images/screenshots/search.png`

Hugo Themes gallery media is stored separately:

- `images/screenshot.png` at `1500x1000`.
- `images/tn.png` at `900x600`.

Both gallery images use a 3:2 aspect ratio. Verify that images render in GitHub's README view and that they reflect the released theme rather than uncommitted local changes.

## Hugo Themes submission

Gallery metadata lives in [theme.toml](../theme.toml), while the supported version range lives in [hugo.toml](../hugo.toml). The repository includes the required screenshot and thumbnail under `images/`.

Follow the [Hugo Themes submission checklist](hugo-themes-submission.md) to add `github.com/joe-mccarthy/termfolio` to `themes.txt` in the Hugo Themes Site Builder repository. Gallery submission is a separate maintainer action after a stable release has been published and verified.

## Release process

[RELEASING.md](../RELEASING.md) is the authoritative maintainer policy. The concise [release checklist](release-checklist.md) covers identity, candidate validation, release writing, media, publication approval, and independent verification.

Release preparation, commit, push, tag creation, tag push, deployment, and Hugo Themes submission are separate operations. The release workflow creates GitHub Releases from approved annotated tags; maintainers do not create them manually.

## Troubleshooting

| Problem | Check |
| --- | --- |
| Hugo reports a missing theme | Run from the repository root and preserve `--themesDir ../.. --theme termfolio`. |
| The example appears under the wrong path | The example's `baseURL` includes `/termfolio/`; use the URL printed by Hugo. |
| The smoke test rejects Hugo | Compare `hugo version` with the optional version argument and supported matrix. |
| Link checks cannot start | Run `npm ci` with the pinned Node.js and npm versions. |
| Lighthouse cannot start | Install Chrome or Chromium and confirm `.public/` was built first. |
| A production build omits content | Check `draft`, future dates, expired dates, and the selected environment. |
| A template change builds but renders incorrectly | Add a representative example page and an assertion to `scripts/test-theme.sh`. |

Configuration-specific problems are covered in [Configuration troubleshooting](configuration.md#troubleshooting).
