---
name: spfx-release
description: Automate SPFx version releases - branch, update files, commit, open PR, then tag after merge
disable-model-invocation: false
allowed-tools: Bash, Read, Edit, Grep
argument-hint: "[version]"
---

# SPFx Release Automation

Release a new SPFx version. The version argument is: $ARGUMENTS

## Pre-flight checks

Before making changes, verify:

1. Working tree is clean (`git status`). If there are unrelated uncommitted changes, stop and ask the user how to handle them.
2. The new version is not already present in `Dockerfile`, `README.md`, or `DevelopmentContainers.md` — if it is, the release may already be in flight; surface this and ask before continuing.
3. The tag `v$ARGUMENTS` does not already exist locally or on origin (`git tag --list`, `git ls-remote --tags origin`).

## Steps to perform

1. **Create a release branch** from the latest master:
   ```
   git checkout master && git pull
   git checkout -b release/v$ARGUMENTS
   ```
   Branch name must be valid git (no spaces, no colons).

2. **Update version in all files** — find and replace the old version with `$ARGUMENTS` in:
   - `Dockerfile` (generator-sharepoint version)
   - `README.md` (Available tags section — update `latest`, `online`, and add the new version row)
   - `DevelopmentContainers.md` (devcontainer.json example)
   - Run `grep -rn "<old-version>"` to catch any other references.

3. **Commit changes** with message: `SPFx v$ARGUMENTS - new version updates`

4. **Squash commits on the release branch** (release branch only — never on master, since unrelated commits between the last tag and HEAD would get folded in):
   - Get the last tag: `git describe --tags --abbrev=0`
   - Soft reset to that tag: `git reset --soft <last-tag>`
   - Re-commit with the same message.

5. **Push the branch and open a PR** (confirm with user first):
   ```
   git push -u origin release/v$ARGUMENTS
   gh pr create --title "feat: new SPFx version v$ARGUMENTS" --body "..."
   ```

6. **After the PR merges**, create and push the tag against the merged commit on master:
   ```
   git checkout master && git pull
   git tag v$ARGUMENTS
   git push origin v$ARGUMENTS
   ```
   Confirm with the user before pushing the tag.

Always confirm with the user before any push or PR creation.
