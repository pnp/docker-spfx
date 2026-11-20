# Agent instructions

Shared instructions for AI coding agents (Claude Code, Codex, GitHub Copilot) working in this repo.

## Versioned docs

The root `README.md` always tracks the latest SPFx version. There is no root `DevelopmentContainers.md`; each `docs/vX.Y.Z/` folder has its own, and the root README's development containers link points to the latest version's copy.

When a new SPFx version is released:

1. Create `docs/vX.Y.Z/`.
2. Copy the current `README.md` and the previous version's `docs/DevelopmentContainers.md` into it.
3. In the copies, change every reference of "latest" to the version:
   - Image tags: `m365pnp/spfx:latest` becomes `m365pnp/spfx:X.Y.Z`. The build pushes each git tag `vX.Y.Z` as image tag `X.Y.Z`.
   - Tag list entries: a `**latest**` entry becomes `**X.Y.Z**`. Remove any duplicate line for that version.
   - The note under the title becomes `> This README covers SharePoint Framework **X.Y.Z**.` followed by a line pointing to the other versions: `> For instructions for other versions, see the versioned docs folder on GitHub: https://github.com/pnp/docker-spfx/tree/main/docs`
4. In the README copy, every link must be an absolute URL. The README is used as the image description on Docker Hub, where no other repo files are available. The development containers link becomes `https://github.com/pnp/docker-spfx/blob/main/docs/vX.Y.Z/DevelopmentContainers.md`.
5. In the DevelopmentContainers copy, update the two-line note under the title to `> This document covers SharePoint Framework **X.Y.Z**.`, and update the devcontainer.json example (`name` and `image`). Its relative links already use the deeper path: `../../assets/` and `../../README.md`.
6. Check that every relative link resolves and that the README copy has no relative links.

Use the existing `docs/v1.24.2/` as the pattern.

## Pull requests

Before creating a PR, remind the user to run `./scripts/test-local.sh` and confirm it passes. It builds the default image, checks the pnpm linker, and builds the npm, pnpm, and yarn test stages.

Open PRs as drafts unless the user asks for a ready-for-review PR.

## Releasing a new SPFx version

Confirm with the user before any `git push`, PR creation, or tag push. Use `X.Y.Z` for the new version.

Pre-flight checks:

1. The working tree is clean (`git status`). If there are unrelated uncommitted changes, stop and ask the user.
2. The new version isn't already in `Dockerfile` or `README.md`. If it is, the release may already be in progress; ask before continuing.
3. The tag `vX.Y.Z` doesn't exist locally or on origin (`git tag --list`, `git ls-remote --tags origin`).

Steps:

1. Create the release branch from the latest main:
   `git checkout main && git pull && git checkout -b release/vX.Y.Z`
2. Update the version:
   - `Dockerfile`: the `@microsoft/generator-sharepoint` version.
   - `README.md`: the version in parentheses in the note under the title, and in the Available tags section update `latest` and `online` and add a row for `X.Y.Z`.
   - `README.md`: the Visual Studio development containers link points to `docs/vX.Y.Z/DevelopmentContainers.md`.
   - Run `grep -rn "<old-version>"` to catch any other references.
3. Create the versioned docs folder as described in "Versioned docs" above.
4. Commit with the message `SPFx vX.Y.Z - new version updates`.
5. Squash the release branch's commits. Never squash on main, since unrelated commits since the last tag would be folded in:
   - Find the last tag: `git describe --tags --abbrev=0`
   - Soft reset to it: `git reset --soft <last-tag>`
   - Commit again with the same message.
6. Push the branch and open a PR: `git push -u origin release/vX.Y.Z`, then `gh pr create --title "feat: new SPFx version vX.Y.Z"`.
7. Merging the PR publishes the release (see "CI flow" below): the image build runs because the Dockerfile changed, pushes the image, creates the `vX.Y.Z` tag on the merge commit, and the Docker Hub description updates. Watch the Actions tab and confirm the tag and image appeared. Never tag by hand before the merge: the repo squash-merges, so a tag on the release branch points at a commit that isn't on main. To re-publish an existing version, push its tag by hand: `git push origin vX.Y.Z`.

## CI flow

- `ci.yml` runs on every PR and push to main. A `changes` job checks whether `Dockerfile`, `docker-bake.hcl`, or the workflow itself changed; only then do the `build` and `test` jobs run. Otherwise they're skipped, which GitHub counts as a passing required check. It does not publish anything.
- `build-and-push.yaml` runs on a push to main that changes `Dockerfile`, and on a `vX.Y.Z` tag push. On a main push it reads the SPFx version from the Dockerfile and stops if that version's tag already exists. Otherwise it builds the multiplatform image, pushes it to Docker Hub as `X.Y.Z`, `latest`, and `online`, and then creates the tag on the merge commit. The tag is created in the same run because a tag pushed with `GITHUB_TOKEN` does not trigger other workflows.
- `update-dockerhub-description.yaml` syncs the root `README.md` to the Docker Hub repository overview. It runs after a successful "Image Build and Push", and on a push to main that changes `README.md` without changing `Dockerfile`. It can also be run manually from the Actions tab.
