#!/bin/bash
# Removes all docker containers and images.
#
# Author: Forest Hoffman <github.com/foresthoffman>
# All rights reserved.
#

echo "Removing all Docker containers."
docker ps -a | awk -F' ' '/[a-z0-9]+/{ print $1 }' | xargs -I % docker rm -f %

echo "Removing all Docker images."
docker images -a | awk -F' ' '/[a-z0-9]+/{ print $3 }' | xargs -I % docker rmi -f %
