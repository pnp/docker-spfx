# SharePoint Framework Docker images

Docker images for running [SharePoint Framework](https://learn.microsoft.com/en-us/sharepoint/dev/spfx/sharepoint-framework-overview).


[![Pulls from Docker Hub](https://img.shields.io/docker/pulls/m365pnp/spfx.svg)](https://hub.docker.com/r/m365pnp/spfx)
[![Stars on Docker Hub](https://img.shields.io/docker/stars/m365pnp/spfx.svg)](https://hub.docker.com/r/m365pnp/spfx)

## Usage

- in **Docker Settings > Resources > File sharing** verify that the drive where you create your projects is shared
- Create a folder for your SharePoint Framework project
- On Linux or WSL, create `~/.rushstack` once first — see [Trusting the development certificate](#trusting-the-development-certificate)
- Start the container **FROM THAT FOLDER** using the command for your hostshell, below

### POSIX shell — bash, zsh, etc. (macOS, Linux, WSL)

```sh
docker run -it --rm --name ${PWD##*/} -u node -p 4321:4321 -p 35729:35729 -v "$PWD":/usr/app/spfx -v ~/.rushstack:/home/node/.rushstack m365pnp/spfx:1.24.0
```

In fish, replace `${PWD##*/}` with `(basename $PWD)`.

### PowerShell (Windows)

```PowerShell
docker run -it --rm --name (Split-Path -Leaf $PWD) -u node -p 4321:4321 -p 35729:35729 -v "${PWD}:/usr/app/spfx" -v "${HOME}\.rushstack:/home/node/.rushstack" m365pnp/spfx:1.24.0
```

### Command Prompt (cmd.exe on Windows)

```cmd
docker run -it --rm --name spfx-helloworld -u node -p 4321:4321 -p 35729:35729 -v "%cd%":/usr/app/spfx -v "%USERPROFILE%\.rushstack":/home/node/.rushstack m365pnp/spfx:1.24.0
```

### Working in the container

After the container starts, you can work with it the same way you would work with SharePoint Framework installed on your host. To create a new SharePoint Framework project in the container command line execute:

```sh
yo @microsoft/sharepoint
```

All files scaffolded by the generator will be stored in your project directory on your host from where you can commit them to source control.

### Trusting the development certificate

The `.rushstack` mount keeps the development certificate on your host, so it survives `--rm` and only has to be trusted once.

1. On Linux or WSL, before starting the container the first time, create the folder that stores the certificate. If Docker creates it instead, it's owned by root and the container can't write to it:

   ```sh
   mkdir -p ~/.rushstack
   ```

2. The first `heft start` creates a certificate authority in the `.rushstack` folder of the home directory mounted into the container. That's the home of the shell you ran `docker run` from. Add it to your trusted root certificates using the command for that shell:

   - WSL prompt (installs into the Windows certificate store):

     ```sh
     certutil.exe -user -addstore Root "$(wslpath -w ~/.rushstack/rushstack-ca.pem)"
     ```

   - PowerShell prompt (installs into the Windows certificate store):

     ```PowerShell
     certutil -user -addstore Root "$HOME\.rushstack\rushstack-ca.pem"
     ```

   - macOS Terminal (installs into your login keychain):

     ```sh
     security add-trusted-cert -r trustRoot -k ~/Library/Keychains/login.keychain-db ~/.rushstack/rushstack-ca.pem
     ```

3. Restart the browser so it picks up the trusted certificate.

### Listening on all interfaces

Before running `heft start`, edit `config/serve.json` in your project so the dev server listens on all interfaces. By default it listens on `localhost` inside the container, which the published ports can't reach. Add `ipAddress`, and remove `hostname` (since it takes precedence over `ipAddress`):

```json
{
  "$schema": "https://developer.microsoft.com/json-schemas/spfx-build/spfx-serve.schema.json",
  //...
  "ipAddress": "0.0.0.0"
}
```

From here, you run the usual `npm` and `heft` commands at the container prompt, exactly as you would with SPFx installed on your host. Edit the project files on your host, since they're shared with the container, and open the workbench in your host browser, since ports 4321 and 35729 are published to it.

To close the container, run the following command from the container prompt:

```sh
exit
```

You can also use this image to build an environment for [Visual Studio development containers](DevelopmentContainers.md)

## Building the image locally

To build the image from this repository instead of pulling it from Docker Hub:

```sh
docker buildx build . --target default --load --tag my-spfx
```

`--load` puts the image in your local image store so `docker run` can find it. Then start it with the command from [Usage](#usage) for your shell, replacing `m365pnp/spfx:1.24.0` with `my-spfx`. For example, in a POSIX shell:

```sh
docker run -it --rm --name ${PWD##*/} -u node \
  -p 4321:4321 -p 35729:35729 \
  -v "$PWD":/usr/app/spfx \
  -v ~/.rushstack:/home/node/.rushstack \
  my-spfx
```

## Known issues

### Unable to write files to disk

When running `yo @microsoft/sharepoint` you get an error that the container is unable to write files to the disk. In most cases this is caused by the drive not being shared in Docker. Go to Docker > Settings > Sharing to enable sharing the drive where your project is located.

### pnpm projects fail to build in SharePoint Framework 1.24.0

Projects scaffolded with `--package-manager pnpm` by generator 1.24.0 fail `heft build` with `TS2416: Property 'dataVersion' ... is not assignable`, because pnpm installs two copies of `@microsoft/sp-core-library`. npm-based projects are not affected.

### Can't access workbench and bundles in SharePoint Framework >=1.14.0

When using the container with SharePoint Framework >=v1.14.0, you can't access the local workbench or can't load bundles in the hosted workbench. This is caused by the default mapping of the workbench to localhost, which isn't accessible outside of the container. To fix it, map the workbench to `0.0.0.0`, by modifying the `./config/serve.json` file in your SharePoint Framework project to:

```json
{
  "$schema": "https://developer.microsoft.com/json-schemas/core-build/serve.schema.json",
  //...
  "ipAddress": "0.0.0.0"
}
```

If `serve.json` also contains a `hostname` property, remove it: it takes precedence over `ipAddress`. Keep browsing to `https://localhost:4321` from the host.

### Can't access workbench and bundles in SharePoint Framework >=1.6.0 <=1.13.1

When using the container with SharePoint Framework >=v1.6.0, you can't access the local workbench or can't load bundles in the hosted workbench. This is caused by the default mapping of the workbench to localhost, which isn't accessible outside of the container. To fix it, map the workbench to `0.0.0.0`, by modifying the `./config/serve.json` file in your SharePoint Framework project to:

```json
{
  "$schema": "https://developer.microsoft.com/json-schemas/core-build/serve.schema.json",
  //...
  "hostname": "0.0.0.0"
}
```

### Can't access bundles in SharePoint Framework 1.13.1

Modify `node_modules\@microsoft\spfx-heft-plugins\lib\plugins\webpackConfigurationPlugin\WebpackConfigurationGenerator.js:393`

```javascript
const debugBaseUrl = `${serveConfig.https ? 'https' : 'http'}://${serveConfig.hostname || 'localhost'}:${serveConfig.port || 4321}/${distFolderName}/`;
```

to:

```javascript
const debugBaseUrl = `${serveConfig.https ? 'https' : 'http'}://localhost:${serveConfig.port || 4321}/${distFolderName}/`;
```

### Can't access bundles in SharePoint Framework 1.12.1

Modify `node_modules\@microsoft\spfx-heft-plugins\lib\plugins\webpackConfigurationPlugin\WebpackConfigurationGenerator.js:376`

```javascript
const debugBaseUrl = `${serveConfig.https ? 'https' : 'http'}://${serveConfig.hostname || 'localhost'}:${serveConfig.port || 4321}/dist/`;
```

to:

```javascript
const debugBaseUrl = `${serveConfig.https ? 'https' : 'http'}://localhost:${serveConfig.port || 4321}/dist/`;
```

### Can't access workbench and bundles in SharePoint Framework >=1.6.0 <=1.11.0 on Windows

When using the container with SharePoint Framework >=v1.6.0 on Windows, you can't access the local workbench despite following the steps from the previous section. This has to do with Windows being unable to correctly access 0.0.0.0. To fix it, first, modify `config\write-manifests.json` to (add the `debugBasePath` property):

```json
{
  "$schema": "https://developer.microsoft.com/json-schemas/spfx-build/write-manifests.schema.json",
  "cdnBasePath": "<!-- PATH TO CDN -->",
  "debugBasePath": "https://localhost:4321/"
}
```

Then, open `node_modules\@microsoft\sp-build-web\lib\SPWebBuildRig.js` and change lines from:

```js
spBuildCoreTasks.writeManifests.mergeConfig({
    debugBasePath: `${serve.taskConfig.https ? 'https' : 'http'}://${serve.taskConfig.hostname}:${serve.taskConfig.port}/`
});
```

to (add the `if` statement):

```js
if (!spBuildCoreTasks.writeManifests.taskConfig.debugBasePath) {
    spBuildCoreTasks.writeManifests.mergeConfig({
        debugBasePath: `${serve.taskConfig.https ? 'https' : 'http'}://${serve.taskConfig.hostname}:${serve.taskConfig.port}/`
    });
}
```

Depending on the SPFx version the lines to replace are different:

| SPFx version | SPWebBuildRig.js lines to replace |
| ------------- | ------------- |
| 1.6.0, 1.7.0 or 1.7.1 | 83-85 |
| 1.8.0, 1.8.1 or 1.8.2 | 88-90 |
| 1.9.1 | 92-94 |
| 1.10.0 or 1.11.0 | 96-98 |

## Limitations

Windows 10 Anniversary Update and Windows Server 2016 have native support for containers. At this moment Windows supports only containers built on Windows Server Core or Nano Server and you won't be able to run this container natively on Windows. Instead you should use Docker for Windows or Docker Toolbox.

## Available tags

- **online**: contains the SharePoint Framework Yeoman generator from the [1.24.0](https://docs.microsoft.com/sharepoint/dev/spfx/release-1.24.0) release
- **onprem**: contains the SharePoint Framework Yeoman generator from the [1.4.1](https://github.com/sharepoint/sp-dev-docs/wiki/Release-Notes-for-SPFx-Package-Version-1.4.1) release
- **1.24.0**: contains the SharePoint Framework Yeoman generator from the [1.24.0](https://docs.microsoft.com/sharepoint/dev/spfx/release-1.24.0) release
- **1.23.2**: contains the SharePoint Framework Yeoman generator from the [1.23.2](https://docs.microsoft.com/sharepoint/dev/spfx/release-1.23.2) release
- **1.23.0**: contains the SharePoint Framework Yeoman generator from the [1.23.0](https://docs.microsoft.com/sharepoint/dev/spfx/release-1.23) release
- **1.22.2**: contains the SharePoint Framework Yeoman generator from the [1.22.2](https://docs.microsoft.com/sharepoint/dev/spfx/release-1.22.2) release
- **1.22.1**: contains the SharePoint Framework Yeoman generator from the [1.22.1](https://docs.microsoft.com/sharepoint/dev/spfx/release-1.22.1) release
- **1.22.0**: contains the SharePoint Framework Yeoman generator from the [1.22.0](https://docs.microsoft.com/sharepoint/dev/spfx/release-1.22) release
- **1.21.1**: contains the SharePoint Framework Yeoman generator from the [1.21.1](https://docs.microsoft.com/sharepoint/dev/spfx/release-1.21.1) release
- **1.21.0**: contains the SharePoint Framework Yeoman generator from the [1.21.0](https://docs.microsoft.com/sharepoint/dev/spfx/release-1.21) release
- **1.20.0**: contains the SharePoint Framework Yeoman generator from the [1.20.0](https://docs.microsoft.com/sharepoint/dev/spfx/release-1.20) release
- **1.19.0**: contains the SharePoint Framework Yeoman generator from the [1.19.0](https://docs.microsoft.com/sharepoint/dev/spfx/release-1.19) release
- **1.18.2**: contains the SharePoint Framework Yeoman generator from the [1.18.2](https://docs.microsoft.com/sharepoint/dev/spfx/release-1.18.2) release
- **1.18.1**: contains the SharePoint Framework Yeoman generator from the [1.18.1](https://docs.microsoft.com/sharepoint/dev/spfx/release-1.18.1) release
- **1.18.0**: contains the SharePoint Framework Yeoman generator from the [1.18.0](https://docs.microsoft.com/sharepoint/dev/spfx/release-1.18) release
- **1.17.4**: contains the SharePoint Framework Yeoman generator from the [1.17.4](https://docs.microsoft.com/sharepoint/dev/spfx/release-1.17.4) release
- **1.17.3**: contains the SharePoint Framework Yeoman generator from the [1.17.3](https://docs.microsoft.com/sharepoint/dev/spfx/release-1.17.3) release
- **1.17.2**: contains the SharePoint Framework Yeoman generator from the [1.17.2](https://docs.microsoft.com/sharepoint/dev/spfx/release-1.17.2) release
- **1.17.1**: contains the SharePoint Framework Yeoman generator from the [1.17.1](https://docs.microsoft.com/sharepoint/dev/spfx/release-1.17.1) release
- **1.17.0**: contains the SharePoint Framework Yeoman generator from the [1.17.0](https://docs.microsoft.com/sharepoint/dev/spfx/release-1.17) release
- **1.16.1**: contains the SharePoint Framework Yeoman generator from the [1.16.1](https://docs.microsoft.com/sharepoint/dev/spfx/release-1.16.1) release
- **1.16.0**: contains the SharePoint Framework Yeoman generator from the [1.16.0](https://docs.microsoft.com/sharepoint/dev/spfx/release-1.16) release
- **1.15.2**: contains the SharePoint Framework Yeoman generator from the [1.15.2](https://docs.microsoft.com/sharepoint/dev/spfx/release-1.15.2) release
- **1.15.0**: contains the SharePoint Framework Yeoman generator from the [1.15.0](https://docs.microsoft.com/sharepoint/dev/spfx/release-1.15) release
- **1.14.0**: contains the SharePoint Framework Yeoman generator from the [1.14.0](https://docs.microsoft.com/sharepoint/dev/spfx/release-1.14) release
- **1.13.1**: contains the SharePoint Framework Yeoman generator from the [1.13.1](https://docs.microsoft.com/sharepoint/dev/spfx/release-1.13.1) release
- **1.13.0**: contains the SharePoint Framework Yeoman generator from the [1.13.0](https://docs.microsoft.com/sharepoint/dev/spfx/release-1.13) release
- **1.12.1**: contains the SharePoint Framework Yeoman generator from the [1.12.1](https://docs.microsoft.com/sharepoint/dev/spfx/release-1.12.1) release
- **1.12.0**: contains the SharePoint Framework Yeoman generator from the 1.12.0 release
- **1.11.0**: contains the SharePoint Framework Yeoman generator from the [1.11.0](https://docs.microsoft.com/sharepoint/dev/spfx/release-1.11.0) release
- **1.10.0**: contains the SharePoint Framework Yeoman generator from the [1.10.0](https://github.com/sharepoint/sp-dev-docs/wiki/SharePoint-Framework-v1.10-release-notes) release
- **1.9.1**: contains the SharePoint Framework Yeoman generator from the [1.9.1](https://github.com/sharepoint/sp-dev-docs/wiki/SharePoint-Framework-v1.9.1-release-notes) release
- **1.8.2**: contains the SharePoint Framework Yeoman generator from the [1.8.2](https://github.com/sharepoint/sp-dev-docs/wiki/SharePoint-Framework-v1.8.2-release-notes) release
- **1.8.1**: contains the SharePoint Framework Yeoman generator from the [1.8.1](https://github.com/sharepoint/sp-dev-docs/wiki/SharePoint-Framework-v1.8.1-release-notes) release
- **1.8.0**: contains the SharePoint Framework Yeoman generator from the [1.8.0](https://github.com/sharepoint/sp-dev-docs/wiki/SharePoint-Framework-v1.8-release-notes) release
- **1.7.1**: contains the SharePoint Framework Yeoman generator from the [1.7.1](https://github.com/sharepoint/sp-dev-docs/wiki/Release-Notes-for-SPFx-Package-Version-1.7.1) release
- **1.7.0**: contains the SharePoint Framework Yeoman generator from the [1.7.0](https://github.com/SharePoint/sp-dev-docs/wiki/SharePoint-Framework-v1.7-release-notes) release
- **1.6.0**: contains the SharePoint Framework Yeoman generator from the [1.6.0](https://github.com/sharepoint/sp-dev-docs/wiki/v-1.6-release-notes) release
- **1.5.1**: contains the SharePoint Framework Yeoman generator from the [1.5.1](https://github.com/SharePoint/sp-dev-docs/wiki/Release-Notes-for-SPFx-Package-Version-1.5.1) release
- **1.5.0**: contains the SharePoint Framework Yeoman generator from the [1.5.0](https://github.com/sharepoint/sp-dev-docs/wiki/Release-Notes-for-SharePoint-Framework-Package-v1.5) release
- **1.4.1**: contains the SharePoint Framework Yeoman generator from the [1.4.1](https://github.com/sharepoint/sp-dev-docs/wiki/Release-Notes-for-SPFx-Package-Version-1.4.1) release
- **1.4.0**: contains the SharePoint Framework Yeoman generator from the [1.4.0](https://github.com/SharePoint/sp-dev-docs/wiki/Release-Notes-for-SPFx-Package-Version-1.4) release
- **1.3.4**: contains the SharePoint Framework Yeoman generator from the [1.3.4](https://dev.office.com/blogs/improved-support-for-office-ui-fabric-core) release
- **1.3.2**: contains the SharePoint Framework Yeoman generator from the 1.3.2 release
- **1.3.1**: contains the SharePoint Framework Yeoman generator from the 1.3.1 release
- **1.3.0**: contains the SharePoint Framework Yeoman generator from the 1.3.0 release
- **1.2.0**: contains the SharePoint Framework Yeoman generator from the [1.2.0](https://github.com/SharePoint/sp-dev-docs/wiki/Release-Notes---Extensions-RC-Drop-1.2) release
- **1.1.3**: contains the SharePoint Framework Yeoman generator from the 1.1.3 release
- **1.1.1**: contains the SharePoint Framework Yeoman generator from the [1.1.1](https://github.com/SharePoint/sp-dev-docs/wiki/Release-Notes---Extensions-Dev-Preview-Drop-1) release
- **1.1.0**: contains the SharePoint Framework Yeoman generator from the [1.1.0](https://github.com/SharePoint/sp-dev-docs/wiki/Release-Notes---Extensions-Dev-Preview-Drop-1) release
- **1.0.2**: contains the SharePoint Framework Yeoman generator from the 1.0.2 release
- **ga**: contains the SharePoint Framework Yeoman generator from the [GA](https://github.com/SharePoint/sp-dev-docs/wiki/Release-Notes-GA) release
- **rc0**: contains the SharePoint Framework Yeoman generator from the [RC0](https://github.com/SharePoint/sp-dev-docs/wiki/Release-Notes-RC0) release
- **drop-6**: contains the SharePoint Framework Yeoman generator from the [developer preview drop 6](https://github.com/SharePoint/sp-dev-docs/wiki/Release-Notes-Drop-6)
- **drop-5**: contains the SharePoint Framework Yeoman generator from the [developer preview drop 5](https://github.com/SharePoint/sp-dev-docs/wiki/Release-Notes-Drop-5)
- **drop-4**: contains the SharePoint Framework Yeoman generator from the [developer preview drop 4](https://github.com/SharePoint/sp-dev-docs/wiki/Release-Notes-Drop-4-and-MDL2)
