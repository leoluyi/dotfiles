#!/usr/bin/env bash

# Show all running containers created by docker-compose < https://stackoverflow.com/a/70915658/3744499 >
expose _DOCKER_PS_BASE='{{.Status}}\t{{.ID}}\t{{.Names}}\t{{.Image}}\t{{.Ports}}\t{{.Networks}}\t{{.Mounts}}'
expose _DOCKER_PS_COMPOSE='{{.Label "com.docker.compose.project"}}\t{{.Label "com.docker.compose.service"}}'

alias docker-ls-compose='docker container ls --all
  --filter label=com.docker.compose.project
  --format "table '"$_DOCKER_PS_COMPOSE\t$_DOCKER_PS_BASE"
