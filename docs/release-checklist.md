# Release Checklist

Use this checklist to prepare and verify an exact Termfolio release candidate.
The detailed policy is in [RELEASING.md](../RELEASING.md).

## Identity

- [ ] Confirm the repository, release unit, channel, version, and tag.
- [ ] Record the exact 40-character candidate commit SHA on `main`.
- [ ] Confirm the proposed tag is absent locally and on GitHub.
- [ ] Confirm no GitHub Release exists for the proposed tag.

## Candidate validation

- [ ] Run `bash scripts/test-theme.sh` with the intended Hugo version.
- [ ] Run `npm ci` followed by `npm run check`.
- [ ] Run `shellcheck scripts/*.sh`.
- [ ] Run `bash scripts/test-release-validator.sh`.
- [ ] Run `git diff --check`.
- [ ] Confirm required GitHub checks pass for the exact candidate commit.
- [ ] Confirm home, posts, projects, taxonomies, search, and error pages render.
- [ ] Confirm the supported standard Hugo versions build with warnings treated
      as errors.

## Documentation and release writing

- [ ] Reconcile `README.md` and the detailed documentation with final behaviour.
- [ ] Confirm `theme.toml` and `hugo.toml` declare the supported Hugo version.
- [ ] Add `## [<version>] - YYYY-MM-DD` to `CHANGELOG.md`.
- [ ] Commit approved notes as `release-notes/<tag>.md`.
- [ ] Document compatibility, required actions, breaking changes, and known
      issues accurately.
- [ ] Confirm the notes and changelog describe only work in the candidate.

## Media

- [ ] Regenerate the walkthrough and README screenshots after visual changes.
- [ ] Regenerate `images/screenshot.png` and `images/tn.png` after gallery-preview
      changes.
- [ ] Verify all committed images render in GitHub's README view.

## Publication approval

- [ ] Review the final diff, checks, version map, notes, and expected assets.
- [ ] Confirm the approved tag will be annotated and target the exact candidate.
- [ ] Approve pushing only `refs/tags/<tag>`.
- [ ] Do not create or edit the GitHub Release manually.

## Independent verification

- [ ] Confirm the public tag object and target commit.
- [ ] Confirm the release status and committed release-note body.
- [ ] Confirm GitHub's source ZIP and tar.gz archives are available.
- [ ] Test the documented installation path from the published source.
- [ ] Record the workflow and release URLs as evidence.

## Hugo Themes

- [ ] Treat gallery submission as a separate action after the stable release is
      verified.
- [ ] Submit the theme to `gohugoio/hugoThemesSiteBuilder` if it is not listed.
- [ ] Confirm the upstream preview succeeds before considering submission done.
