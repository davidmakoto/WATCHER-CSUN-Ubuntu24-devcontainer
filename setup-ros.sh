#!/bin/bash

set -e

echo "=== Setting up locale ==="
sudo apt update
sudo apt install -y locales
sudo locale-gen en_US en_US.UTF-8
sudo update-locale LC_ALL=en_US.UTF-8 LANG=en_US.UTF-8
export LANG=en_US.UTF-8

echo "=== Enabling required repositories ==="
sudo apt install -y software-properties-common
sudo add-apt-repository -y universe

echo "=== Installing ROS 2 apt source ==="
sudo apt update
sudo apt install -y curl
export ROS_APT_SOURCE_VERSION=$(curl -s https://api.github.com/repos/ros-infrastructure/ros-apt-source/releases/latest | grep -F "tag_name" | awk -F'"' '{print $4}')
curl -L -o /tmp/ros2-apt-source.deb "https://github.com/ros-infrastructure/ros-apt-source/releases/download/${ROS_APT_SOURCE_VERSION}/ros2-apt-source_${ROS_APT_SOURCE_VERSION}.$(. /etc/os-release && echo $VERSION_CODENAME)_all.deb"
sudo dpkg -i /tmp/ros2-apt-source.deb

echo "=== Installing ROS 2 Jazzy ==="
sudo apt update
sudo apt upgrade -y
sudo apt install -y ros-jazzy-desktop

echo "=== Installing development tools ==="
sudo apt install -y ros-dev-tools

echo "=== Setting up ROS 2 environment ==="
echo 'source /opt/ros/jazzy/setup.bash' >> ~/.bashrc

echo "=== ROS 2 Jazzy installation complete! ==="

echo "=== Installing Gazebo Harmonic ==="
sudo apt-get update
sudo apt-get install -y lsb-release gnupg

sudo curl https://packages.osrfoundation.org/gazebo.gpg --output /usr/share/keyrings/pkgs-osrf-archive-keyring.gpg
echo "deb [arch=$(dpkg --print-architecture) signed-by=/usr/share/keyrings/pkgs-osrf-archive-keyring.gpg] https://packages.osrfoundation.org/gazebo/ubuntu-stable $(lsb_release -cs) main" | sudo tee /etc/apt/sources.list.d/gazebo-stable.list > /dev/null
sudo apt-get update
sudo apt-get install -y gz-harmonic

echo "=== Gazebo Harmonic installation complete! ==="
echo "=== All installations finished successfully! ==="
