---
name: spfx-release
description: Automate SPFx version releases - updates files, commits, squashes, tags, and pushes
disable-model-invocation: false
allowed-tools: Bash, Read, Edit, Grep
argument-hint: [version]
---

# SPFx Release Automation

Release a new SPFx version. The version argument is: $ARGUMENTS

## Steps to perform:

1. **Update version in all files** - Find and replace the old version with the new one in:
   - Dockerfile (generator-sharepoint version)
   - README.md (Available tags section - update latest, online, and add new version tag)
   - DevelopmentContainers.md (devcontainer.json example)
   - any other files you find references to the SPFx version.

2. **Commit changes** with message: `SPFx v$ARGUMENTS - new version updates`

3. **Squash commits since last tag**:
   - Get the last tag: `git describe --tags --abbrev=0`
   - Soft reset to that tag: `git reset --soft <last-tag>`
   - Re-commit with the same message

4. **Create new tag**: `git tag v$ARGUMENTS`

5. **Push to GitHub**:
   - Push branch: `git push origin master`
   - Push tag: `git push origin v$ARGUMENTS`

Always confirm with the user before pushing.
