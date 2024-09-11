#!/usr/bin/env bash

# where is this script is running?
WHERE=$(dirname "$(realpath "$0")")

# the project is the basename
PROJECT=$(basename "$WHERE")

# construct the filter for docker volume ls
FILTER="label=com.docker.compose.project=$PROJECT"

# clobber the stack
docker compose down

# fetch list of named volumes associated with this project
VOLUMES=$(docker volume ls --filter "$FILTER" --format json | jq -r .Name)

# is the list non-empty?
if [ -n "$VOLUMES" ] ; then
	# yes! iterate to remove
	echo "Removing named volume mounts for project \"$PROJECT\""
	for VOLUME in $VOLUMES ; do
		docker volume rm "$VOLUME"
	done
else
	echo "No named volume mounts to remove for project \"$PROJECT\""
fi

# new filter
FILTER="dangling=true"

# fetch list of dangling anonymous volumes (may or may not be associated with this project)
VOLUMES=$(docker volume ls --filter "$FILTER" --format json | jq -r .Name)

# is the list non-empty?
if [ -n "$VOLUMES" ] ; then
	# yes! iterate to remove
	echo "Removing dangling anonymous volume mounts for all projects on this host"
	for VOLUME in $VOLUMES ; do
		docker volume rm "$VOLUME"
	done
else
	echo "No dangling anonymous volume mounts to remove"
fi

# point to the Docker bind mounts folder
VOLUMES="./volumes"

if [ -d "$VOLUMES" ] ; then
	echo "Removing Docker bind mounts in $WHERE"
	sudo rm -rfv "$VOLUMES"
else
	echo "No Docker bind mounts to remove"
fi
