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

- In the command line (on Windows, assuming your project is located at `c:\projects\spfx-helloworld`):

```sh
cd c:\projects\spfx-helloworld
docker run -it --rm --name spfx-helloworld -v /c/projects/spfx-helloworld:/usr/app/spfx -p 5432:5432 -p 4321:4321 -p 35729:35729 waldekm/spfx
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

- **latest**: contains the SharePoint Framework Yeoman generator from the [1.3.4](https://dev.office.com/blogs/improved-support-for-office-ui-fabric-core) release
- **online**: contains the SharePoint Framework Yeoman generator from the [1.3.4](https://dev.office.com/blogs/improved-support-for-office-ui-fabric-core) release
- **onprem**: contains the SharePoint Framework Yeoman generator from the [1.3.4](https://dev.office.com/blogs/improved-support-for-office-ui-fabric-core) release
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

When running `yo @microsoft/sharepoint` you get an error that the container is unable to write files to the disk. In most cases this is caused by the drive not being shared in Docker. Go to Docker > Settings > Sharing to enable sharing the drive where your project is located.

## Limitations

Windows 10 Anniversary Update and Windows Server 2016 have native support for containers. At this moment Windows supports only containers built on Windows Server Core or Nano Server and you won't be able to run this container natively on Windows. Instead you should use Docker for Windows or Docker Toolbox.
