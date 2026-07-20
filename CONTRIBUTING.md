# Contributing

Thank you for considering a contribution to Termfolio. Focused bug fixes, documentation improvements, accessibility work, compatibility fixes, and well-scoped features are welcome.

Please keep project discussions respectful, constructive, and centred on the work.

## Before you start

- Search existing issues and pull requests before opening a duplicate.
- Use the [support guide](SUPPORT.md) to choose the appropriate issue form.
- Discuss substantial features before investing in a large implementation.
- Keep unrelated refactoring out of a focused bug fix or feature change.

Small documentation corrections and clearly contained fixes can go directly to a pull request.

## Development setup

Clone the repository and install the pinned development dependencies:

```bash
git clone https://github.com/joe-mccarthy/termfolio
cd termfolio
npm ci
```

Use Hugo `0.128.0` or newer. Standard Hugo is sufficient; Hugo Extended is not required. Node.js and npm versions are declared in [.node-version](.node-version) and [package.json](package.json).

Run the example site while developing:

```bash
hugo server --source example-site --themesDir ../.. --theme termfolio
```

The [development guide](docs/development.md) describes the repository structure, example fixture, media workflow, and complete toolchain.

## Making a change

1. Create a focused branch from the latest `main`.
2. Add or update an example-site fixture when behaviour needs rendering coverage.
3. Update configuration, content, or maintainer documentation when a public contract changes.
4. Add screenshots for visible layout or styling changes.
5. Run the relevant local checks before opening a pull request.

For example:

```bash
git switch -c fix/concise-description
```

Follow the existing style in Hugo templates, YAML, Markdown, CSS, and shell scripts. Avoid adding runtime dependencies or third-party assets without explaining their user, privacy, performance, and maintenance impact.

## Validation

The complete local suite is:

```bash
bash scripts/test-theme.sh
npm ci
npm run check
shellcheck scripts/*.sh
bash scripts/test-release-validator.sh
git diff --check
```

Run checks relevant to the files you changed, and run the complete suite when changing shared layouts, compatibility behaviour, automation, dependencies, or release tooling. See [Development](docs/development.md#local-checks) for the accessibility fixture and CI matrix.

Do not weaken a check to make a change pass. If a check is not applicable or cannot run locally, explain that clearly in the pull request.

## Pull requests

A useful pull request:

- Explains the problem and why the change belongs in Termfolio.
- Links the related issue when one exists.
- Describes user-visible and compatibility effects.
- Lists the exact validation performed.
- Updates documentation and example content where needed.
- Includes before-and-after screenshots for visual changes.
- Avoids generated output, editor files, and unrelated formatting churn.

Maintainers may request a smaller scope, additional tests, documentation changes, or compatibility evidence before merging. Required CI checks must pass on the final commit.

Version selection, changelog entries, release notes, tags, and publication are maintainer-owned release tasks. Do not change them unless the pull request is explicitly preparing an approved release.

## Licence

Contributions accepted into Termfolio are distributed under the repository's [MIT License](LICENSE).
