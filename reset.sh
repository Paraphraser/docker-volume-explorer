#!/usr/bin/env bash

# where is this script is running?
WHERE=$(dirname "$(realpath "$0")")

# clobber the stack - the -v option removes all named volume mounts
# declared in the compose file plus any anonymous volume mounts in
# use by a running container. It does not clobber any dangling
# anonymous volume mounts. It does not clobber any bind mounts.
docker compose down -v

# follow-up by clobbering any dangling anonymous volume mounts
docker system prune -f --volumes

# point to the Docker bind mounts folder
VOLUMES="./volumes"

if [ -d "$VOLUMES" ] ; then
	echo "Removing Docker bind mounts in $WHERE"
	sudo rm -rfv "$VOLUMES"
else
	echo "No Docker bind mounts to remove"
fi
