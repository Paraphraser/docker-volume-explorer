#!/usr/bin/env bash

SCRIPT="$(basename "$0")" # assumes "show_declared_volumes.sh"

# no arguments supported
if [ $# -gt 0 ] ; then
	echo -e "\nUsage: $SCRIPT"
	echo -e "\nReturns declared volumes for all images known to the host. Takes no arguments."
	exit 1
fi

# iterate all images on this system
curl -s --unix-socket /var/run/docker.sock http://localhost/images/json \
	| jq -r .[].RepoTags[0] \
	| while read IMAGE ; do
		echo "Declared VOLUMES for image \"$IMAGE\""
		docker image inspect "$IMAGE" \
			| jq .[].Config.Volumes \
			| sed -e "s/^/  /"
		echo ""
	done
