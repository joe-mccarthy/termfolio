# Releasing

This document defines how maintainers prepare, publish, and verify a Termfolio
release. Everything in the repository is released together under one version.

## Release contract

- Releases come from an exact commit on `main`.
- Versions follow Semantic Versioning and tags use a leading `v`.
- Release tags are annotated and immutable after publication.
- Approved release notes are committed under `release-notes/`.
- `CHANGELOG.md` is the long-term version history.
- [.github/workflows/release.yml](.github/workflows/release.yml) is the only
  mechanism that creates GitHub Releases.
- Publishing a release does not deploy the example site.

The publication workflow accepts stable tags such as `v1.2.3` and prerelease
tags such as `v1.2.3-alpha.1`, `v1.2.3-beta.1`, or `v1.2.3-rc.1`. Numeric
components must not have leading zeroes, and build metadata is not accepted.

## Choose a version

Use the largest Semantic Versioning increment required by the release:

- PATCH for backward-compatible fixes.
- MINOR for backward-compatible functionality.
- MAJOR for incompatible behaviour.

Use a prerelease only when the candidate needs public testing before a stable
release. Increment the prerelease number for each replacement candidate.

Never reuse a version or tag after publication. Correct a defective release
with a new version.

## Prepare the candidate

The candidate must contain only the intended release work and must be reachable
from `main`. Before requesting publication approval, run the relevant local
checks and confirm the required GitHub checks pass for the exact commit.

The complete local suite includes:

```bash
bash scripts/test-theme.sh
npm ci
npm run check
shellcheck scripts/*.sh
bash scripts/test-release-validator.sh
git diff --check
```

CI additionally renders the example with the minimum and current standard Hugo
versions and runs the browser-based accessibility checks.

## Write the release artifacts

Commit the approved user-facing notes as `release-notes/<tag>.md`. For example,
the notes for `v1.0.0` are stored at `release-notes/v1.0.0.md`. The file must be
non-empty and identical to the copy in the tagged commit.

Add a dated, bracketed heading to `CHANGELOG.md`:

```text
## [1.0.0] - 2026-07-20
```

Release notes should lead with user impact and include compatibility, required
actions, installation guidance, breaking changes, and known issues when
relevant. Reconcile the notes and changelog against the final diff before
publication.

## Review the publication identity

Publication approval must identify:

- Repository and release unit.
- Stable or prerelease channel.
- Version and tag.
- Exact 40-character candidate commit SHA.
- Release-notes path and changelog heading.
- Expected assets and publication destination.

Confirm the tag and GitHub Release do not already exist. Preparing changes,
committing, pushing a branch, merging, creating a tag, and pushing that tag are
separate actions.

## Publish through automation

After the exact candidate and tag push are approved, create an annotated tag on
the approved commit and push only that tag. For example:

```bash
git tag --annotate v1.0.0 <approved-sha> --message "Termfolio v1.0.0"
git push origin refs/tags/v1.0.0
```

Do not create or edit the GitHub Release manually. The tag push starts
`.github/workflows/release.yml`, which verifies:

- The tag format and annotated object type.
- The exact event commit and `main` ancestry.
- The committed notes and bracketed changelog heading.
- Local and GitHub tag-object parity.
- The absence of an existing GitHub Release.

Stable tags create the latest stable release. Prerelease tags create a GitHub
prerelease and do not replace the latest stable release. The expected assets are
GitHub's source ZIP and tar.gz archives; additional packages require their own
approved build and verification contract.

## Verify the public result

A successful workflow is evidence, not completion. Verify directly that:

- The public annotated tag targets the approved commit.
- The GitHub Release exists with the correct stable or prerelease status.
- The published body matches the committed notes.
- The source ZIP and tar.gz archives are available.
- The documented installation path works from the published source.

Record the workflow URL, release URL, tag object, target commit, and installation
evidence. Deployment and a Hugo Themes submission are separate follow-up units.

## Recover safely

If validation fails after a tag push, the tag is already public. Do not delete,
move, or reuse it; diagnose the failure and prepare a new version when tagged
content must change.

If release creation succeeds but a later postcondition fails, record the state
as partial publication before any recovery action. Rerun the workflow only for
a transient failure when it will operate on the same immutable tag and commit.
