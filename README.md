# Purpose
Create devcontainer environment that runs ubuntu 24.04 based on official template
https://github.com/devcontainers/templates/tree/main/src/ubuntu

# Requirements

Devcontainer CLI
Docker

# Running instructions

```bash
# build the devcontainer from the ./.devcontainer/.devcontainer.json file
devcontainer up --workspace-folder .

# run interactive bash session with the container
devcontainer exec --workspace-folder . bash

```


# Next steps
To install ROS2 from here follow the official documentation on how to do it via the cli

https://docs.ros.org/en/jazzy/Installation/Ubuntu-Install-Debs.html
