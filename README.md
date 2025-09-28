# Purpose
Create devcontainer environment that runs ubuntu 24.04 based on official template
https://github.com/devcontainers/templates/tree/main/src/ubuntu

# Requirements

[Devcontainer CLI](https://github.com/devcontainers/cli)

[Docker](https://www.docker.com/)

# Running instructions

Copy repo
```bash
git clone https://github.com/davidmakoto/WATCHER-csun-ubuntu24-devcontainer.git
```

Change dir to new folder
```bash
cd WATCHER-csun-ubuntu24-devcontainer
```

## Create dev container and install ROS2 (desktop) during build
This will trigger the devcontainer's postCreateCommand which is an exact copy of the [documentation's installation instructions for ROS2 Jazzy Jalisco's](https://docs.ros.org/en/jazzy/Installation/Ubuntu-Install-Debs.html)

Note: there are still configurations needed to run the examples and you should read through the end of the docs at the very least
```bash
# build the devcontainer from the ./.devcontainer/devcontainer.json file
devcontainer up --workspace-folder .
```

## Create interactive bash shell with devcontainer
```bash
devcontainer exec --workspace-folder . bash
```
