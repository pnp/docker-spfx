# Examples of Pipelines

## GitHub Actions

```yaml
name: Build

on:
  workflow_dispatch:
  push: 
    branches:
      - main
    paths:
      - 'src/**'
      - '.github/workflows/build.yaml'
jobs:
  build:
    runs-on: ubuntu-latest
    container:
      image: m365pnp/spfx:1.14.0
    steps:
      - uses: actions/checkout@v2
      - run: npm install
      - run: gulp bundle --ship
```

Reference run: https://github.com/alexsapozhkov/codespaces-test-04/runs/7358446857?check_suite_focus=true

## Azure DevOps Pipelines

```yaml
name: $(Date:yyyyMMdd).$(Rev:.r)
trigger:
  branches:
    include:
    - main
jobs:
- job:
  displayName: Building
  container: m365pnp/spfx:1.14.0
  steps:
  - script: npm install
  - script: gulp bundle --ship
```

Reference run: 

## GitLab CI/CD

```yaml
build-test:
  stage: build
  rules:
    - changes:
      - src/*
      - .gitlab-ci.yml
  image:
    name: m365pnp/spfx:1.14.0
  script:
    - npm install
    - gulp bundle --ship
```

Reference run: https://gitlab.com/shurick81/spfx-demo-00/-/jobs/2728043216
