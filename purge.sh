#!/bin/bash
# Removes docker containers and images.
#
# Author: Forest Hoffman <github.com/foresthoffman>
# All rights reserved.
#

excludeImagePattern="example"
options=('-n' '--name' '-i' '--images' '-h' '--help')

error() {
	echo "ERROR: $1"
}

usage() {
cat << END
⚡️ Docker Purge⚡️
Remove Docker containers and images.

Usage: docker-purge [options]

${options[0]}, ${options[1]} [pattern]	Purge containers matching the provided name pattern, default: '.*'.
${options[2]}, ${options[3]}	Purge images as well as containers, default: OFF (Ignores '${options[1]}' option).
${options[4]}, ${options[5]}	This information.
END
}

namePattern=""
allImages=false
index=0
for arg in $@; do
	index=$(echo "$index+1" | bc)
	# help menu
	if [[ "$arg" == "${options[4]}" ]] || [[ "$arg" == "${options[5]}" ]]; then
		usage
		exit 0
	fi
	# by name
	if [[ "$arg" == "${options[0]}" ]] || [[ "$arg" == "${options[1]}" ]]; then
		next=$(echo $index+1 | bc)
		if [[ "${!next}" == "" ]] || [[ "$(echo ${!next} | grep -E '^-')" == "${!next}" ]]; then
			error "A valid pattern is required for the '${options[1]}' option."
			usage
			exit 1
		fi
		namePattern="${!next}"
		continue
	fi
	# all images
	if [[ "$arg" == "${options[2]}" ]] || [[ "$arg" == "${options[3]}" ]]; then
		allImages=true
		continue
	fi
done

removeStr="Removing all Docker containers"
if [[ "${namePattern}" != "" ]]; then
	echo "${removeStr} with names matching '${namePattern}'."
	docker ps --filter name="${namePattern}" --format "{{.Names}}" | xargs -I '%' docker rm -f %
else
	echo "${removeStr}."
	docker ps -a --format "{{.Names}}" | xargs -I '%' docker rm -f %
fi

if $allImages; then
	echo "Removing all Docker images."
	docker images -a | awk -F' ' "/$excludeImagePattern/{ next } /[a-z0-9]+/{ print \$3 }" | xargs -I % docker rmi -f %
fi
