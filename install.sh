#!/bin/bash
# Installs the docker-purge executable.
#
# Author: Forest Hoffman <github.com/foresthoffman>
# All rights reserved.
#

target=/usr/bin/docker-purge
if [[ ! -f "$target" ]]; then
  echo "Copying to $target."
  cp ./purge.sh
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
chmod u+x $target

echo "All done!"
