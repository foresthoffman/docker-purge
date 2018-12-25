#!/bin/bash
# Installs the docker-purge executable.
#
# Author: Forest Hoffman <github.com/foresthoffman>
# All rights reserved.
#

if [[ "$(which docker)" == "" ]]; then
  echo "Docker is not installed, do so at https://www.docker.com/, and then run this script again."
  exit 1
fi

dockerBin="$(dirname $(which docker))"
target="${dockerBin}/docker-purge"
if [[ ! -f "$target" ]]; then
  echo "Copying to $target."
  cp ./purge.sh $target
else
  echo "$target already exists."
  if [[ "$1" != "-f" ]]; then
    echo "Run the command again with the '-f' option to override."
    exit 1
  fi
  echo "Attempting to override $target."
  cp -f ./purge.sh $target
fi

echo "Attemtping to make $target executable"
chmod +x $target
chown $(whoami) $target

echo "All done!"
