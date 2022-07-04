# Contribution guidelines

We appreciate that you're interested in helping with moving the project forward. Before you submit your first PR, please read the following guide. We'd hate to see you work on something that someone else is already working on, something that we agreed not to do or something that doesn't match the project.

Sharing is caring!

## You have an idea for an improvement/feature

Awesome! Good ideas are invaluable for every project. Before you start hacking away, please check if there is no similar idea already listed in the [issue list](https://github.com/pnp/docker-spfx/issues). If not, please create a new issue describing your idea. Once we agree on the feature scope and architecture, the feature will be ready for building. Don't hesitate to mention in the issue if you'd like to build the feature yourself.

## You've found a bug

Bugs happen. When you find a bug, please have a look at the [issue list](https://github.com/pnp/docker-spfx/issues) if a similar bug has already been logged. If not, let us know what doesn't work and how we can reproduce it. If we can't reproduce your bug, we will ask you for clarification, which will only make it longer to fix it.

## Fixing typos

Typos are embarrassing! Most PR's that fix typos will be accepted immediately. In order to make it easier to review the PR, please narrow the focus instead of sending a huge PR of fixes.

## Tips

Before contributing:

- ensure that the **main** branch on your fork is in sync with the original **docker-spfx** repository

    ```sh
    # assuming you are in the folder of your locally cloned fork....
    git checkout main

    # assuming you have a remote named `upstream` pointing to the official **docker-spfx** repo
    git fetch upstream

    # update your local main to be a mirror of what's in the main repo
    git pull --rebase upstream main
    ```

- create a feature branch for your change. If you'll get stuck on an issue or merging your PR will take a while, this will allow you to have a clean main branch that you can use for contributing other changes

    ```sh
    git checkout -b my-contribution
    ```

## DO's & DON'Ts

- **DO** follow the same structure as the existing project.
- **DO** keep discussions focused. When a new or related topic comes up it's often better to create new issue than to side track the conversation.
- **DO NOT** submit PR's for coding style changes.
- **DO NOT** surprise us with PR's. Instead file an issue & start a discussion so we can agree on a direction before you invest a large amount of time.
- **DO NOT** commit code you didn't write.
- **DO NOT** submit PR's that refactor existing code without a discussion first.

## Debugging locally

### Building from Dockerfile

```sh
docker build -t docker-spfx-00 .
```

### Testing a new project

```sh
docker run --rm -it -p 4321:4321 -p 35729:35729 docker-spfx-00
```

Run in the new container:

```sh
cd /home/spfx
yo @microsoft/sharepoint --solution-name helloworld --component-type webpart --component-name hello-world-webpart --component-description "HelloWorld web part" --is-domain-isolated false --framework none --environment spo --skip-feature-deployment false --no-insight
cd helloworld/
cat <<EOF | tee config/serve.json
{
  "\$schema": "https://developer.microsoft.com/json-schemas/core-build/serve.schema.json",
  "port": 4321,
  "ipAddress": "0.0.0.0",
  "https": true,
  "initialPage": "https://enter-your-SharePoint-site/_layouts/workbench.aspx"
}
EOF
gulp trust-dev-cert
gulp serve --nobrowser
```

Add the certificate to trusted certificates on your machine, open the workbench and add the web part.
