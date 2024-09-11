#!/usr/bin/env bash

VOLUMES="./volumes"

if [ -d "$VOLUMES" ] ; then
	tree -apug --noreport "$VOLUMES"
else
	echo "No bind mounts exist"
fi
