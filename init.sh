#! /usr/bin/bash

install_docker() {
  # Add Docker's official GPG key:
  apt-get update
  apt-get install ca-certificates curl
  install -m 0755 -d /etc/apt/keyrings
  curl -fsSL https://download.docker.com/linux/ubuntu/gpg -o /etc/apt/keyrings/docker.asc
  chmod a+r /etc/apt/keyrings/docker.asc

  # Add the repository to Apt sources:
  echo \
    "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.asc] https://download.docker.com/linux/ubuntu \
    $(. /etc/os-release && echo "$VERSION_CODENAME") stable" | \
    tee /etc/apt/sources.list.d/docker.list > /dev/null
  apt-get update

  apt-get install -y docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin

  groupadd docker
  usermod -aG docker testuser
  newgrp docker
}

run_application() {
  cd /home
  git clone "${OPTARG}" app
  cd app
  ./replace_in_code.sh -c
  cd app-code
  docker compose up -d
}

########## BEGIN SCRIPT ##########
getopts ':r:' option
install_docker
run_application
