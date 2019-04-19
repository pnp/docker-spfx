# SharePoint Framework Docker images

Docker images for running [SharePoint Framework](https://github.com/SharePoint/sp-dev-docs).


[![Pulls from Docker Hub](https://img.shields.io/docker/pulls/waldekm/spfx.svg)](https://hub.docker.com/r/waldekm/spfx)
[![Stars on Docker Hub](https://img.shields.io/docker/stars/waldekm/spfx.svg)](https://hub.docker.com/r/waldekm/spfx)

## Usage

- in **Docker Settings > Shared Drives** verify that the drive where you create your projects is shared
- Create a folder for your SharePoint Framework project
- In the command line (on macOS):

```sh
cd [your project]
docker run -it --rm --name ${PWD##*/} -v $PWD:/usr/app/spfx -p 5432:5432 -p 4321:4321 -p 35729:35729 waldekm/spfx
```

- In PowerShell on Windows:

```PowerShell
cd [your project]
docker run -it --rm --name spfx-helloworld -v ${PWD}:/usr/app/spfx -p 5432:5432 -p 4321:4321 -p 35729:35729 waldekm/spfx
```

- In other shells on Windows

```cmd
cd [your project]
docker run -it --rm --name spfx-helloworld -v %cd%:/usr/app/spfx -p 5432:5432 -p 4321:4321 -p 35729:35729 waldekm/spfx
```

After the container started you can work with it the same way you would work with SharePoint Framework installed on your host. To create a new SharePoint Framework project in the container command line execute:

```sh
yo @microsoft/sharepoint
```

To open the SharePoint workbench navigate in the browser to **https://localhost:5432/workbench**.

All files scaffolded by the generator will be stored in your project directory on your host from where you can commit them to source control.

To close the container in the container command line run:

```sh
exit
```

## Available tags

- **latest**: contains the SharePoint Framework Yeoman generator from the [1.8.2](https://github.com/sharepoint/sp-dev-docs/wiki/SharePoint-Framework-v1.8.2-release-notes) release
- **online**: contains the SharePoint Framework Yeoman generator from the [1.8.2](https://github.com/sharepoint/sp-dev-docs/wiki/SharePoint-Framework-v1.8.2-release-notes) release
- **onprem**: contains the SharePoint Framework Yeoman generator from the [1.8.2](https://github.com/sharepoint/sp-dev-docs/wiki/SharePoint-Framework-v1.8.2-release-notes) release
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

## Known issues

### Unable to write files to disk

When running `yo @microsoft/sharepoint` you get an error that the container is unable to write files to the disk. In most cases this is caused by the drive not being shared in Docker. Go to Docker > Settings > Sharing to enable sharing the drive where your project is located.

### Can't access workbench and bundles in SharePoint Framework >=1.6.0

When using the container with SharePoint Framework >=v1.6.0, you can't access the local workbench or can't load bundles in the hosted workbench. This is caused by the default mapping of the workbench to localhost, which isn't accessible outside of the container. To fix it, map the workbench to `0.0.0.0`, by modifying the `./config/serve.json` file in your SharePoint Framework project to:

```json
{
  "$schema": "https://developer.microsoft.com/json-schemas/core-build/serve.schema.json",
  "port": 4321,
  "hostname": "0.0.0.0",
  "https": true,
  "initialPage": "https://localhost:5432/workbench",
  "api": {
    "port": 5432,
    "entryPath": "node_modules/@microsoft/sp-webpart-workbench/lib/api/"
  }
}
```

### Can't access workbench and bundles in SharePoint Framework >=1.6.0 on Windows

When using the container with SharePoint Framework >=v1.6.0 on Windows, you can't access the local workbench despite following the steps from the previous section. This has to do with Windows being unable to correctly access 0.0.0.0. To fix it, first, modify `config\write-manifests.json` to (add the `debugBasePath` property):

```json
{
  "$schema": "https://developer.microsoft.com/json-schemas/spfx-build/write-manifests.schema.json",
  "cdnBasePath": "<!-- PATH TO CDN -->",
  "debugBasePath": "https://localhost:4321/"
}
```

Then, open `node_modules\@microsoft\sp-build-web\lib\SPWebBuildRig.js` and change lines 83-85 from:

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

### Can't access workbench and bundles in SharePoint Framework 1.5.0

When using the container with SharePoint Framework v1.5.0, you can't access the local workbench or can't load bundles in the hosted workbench. This is caused by a change to the `gulp-connect` package used by the `gulp serve` task. To fix the issue, after scaffolding the project, in the code editor open the `./node_modules/gulp-connect/index.js` file and change line 106 from:

```js
return this.server.listen(this.port, this.host, (function(_this) {
```

to (remove the `this.host` argument):

```js
return this.server.listen(this.port, (function(_this) {
```

## Limitations

Windows 10 Anniversary Update and Windows Server 2016 have native support for containers. At this moment Windows supports only containers built on Windows Server Core or Nano Server and you won't be able to run this container natively on Windows. Instead you should use Docker for Windows or Docker Toolbox.
