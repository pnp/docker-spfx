# Agent instructions

Shared instructions for AI coding agents (Claude Code, Codex, GitHub Copilot) working in this repo.

## Versioned docs

The root `README.md` and `docs/DevelopmentContainers.md` always track the latest SPFx version.

When a new SPFx version is released:

1. Create `docs/vX.Y.Z/`.
2. Copy the current `README.md` and `docs/DevelopmentContainers.md` into it.
3. In the copies, change every reference of "latest" to the version:
   - Image tags: `m365pnp/spfx:latest` becomes `m365pnp/spfx:X.Y.Z`. The build pushes each git tag `vX.Y.Z` as image tag `X.Y.Z`.
   - Tag list entries: a `**latest**` entry becomes `**X.Y.Z**`. Remove any duplicate line for that version.
4. Fix relative links for the deeper path: `../assets/` becomes `../../assets/`, and `../README.md` becomes `../../README.md`.
5. Check that every relative link resolves.

Use the existing `docs/v1.24.0/` as the pattern.

## Pull requests

Before creating a PR, remind the user to run `./scripts/test-local.sh` and confirm it passes. It builds the default image, checks the pnpm linker, and builds the npm, pnpm, and yarn test stages.

Open PRs as drafts unless the user asks for a ready-for-review PR.

## Releasing a new SPFx version

Confirm with the user before any `git push`, PR creation, or tag push. Use `X.Y.Z` for the new version.

Pre-flight checks:

1. The working tree is clean (`git status`). If there are unrelated uncommitted changes, stop and ask the user.
2. The new version isn't already in `Dockerfile`, `README.md`, or `docs/DevelopmentContainers.md`. If it is, the release may already be in progress; ask before continuing.
3. The tag `vX.Y.Z` doesn't exist locally or on origin (`git tag --list`, `git ls-remote --tags origin`).

Steps:

1. Create the release branch from the latest main:
   `git checkout main && git pull && git checkout -b release/vX.Y.Z`
2. Update the version:
   - `Dockerfile`: the `@microsoft/generator-sharepoint` version.
   - `README.md`: in the Available tags section, update `latest` and `online` and add a row for `X.Y.Z`.
   - `docs/DevelopmentContainers.md`: the devcontainer.json example.
   - Run `grep -rn "<old-version>"` to catch any other references.
3. Create the versioned docs folder as described in "Versioned docs" above.
4. Commit with the message `SPFx vX.Y.Z - new version updates`.
5. Squash the release branch's commits. Never squash on main, since unrelated commits since the last tag would be folded in:
   - Find the last tag: `git describe --tags --abbrev=0`
   - Soft reset to it: `git reset --soft <last-tag>`
   - Commit again with the same message.
6. Push the branch and open a PR: `git push -u origin release/vX.Y.Z`, then `gh pr create --title "feat: new SPFx version vX.Y.Z"`.
7. After the PR merges, tag the merged commit on main: `git checkout main && git pull && git tag vX.Y.Z && git push origin vX.Y.Z`.
