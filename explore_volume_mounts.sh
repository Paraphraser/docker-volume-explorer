#!/usr/bin/env bash

# fetch the list of mountpoints (as in "mount mountpoint target")
# (this will capture all named and anonymous volumes, both associated
# with the current project and elsewhere on the system)
MOUNTPOINTS=$(docker volume ls --format json | jq -r .Mountpoint)

if [ -n "$MOUNTPOINTS" ] ; then
	for MOUNTPOINT in $MOUNTPOINTS ; do
		sudo tree -apug --noreport $MOUNTPOINT
		echo "------------------------------------------------------"
	done
else
	echo "No volume mounts exist"
fi
