#!/usr/bin/env bash

# external proxy for invoking internal script of the same name
SCRIPT=$(basename "$0")
SERVICES="test1 test2"

# useful function
isContainerRunning() {
	if STATUS=$(curl -s --unix-socket /var/run/docker.sock http://localhost/containers/$1/json | jq .State.Status) ; then
		[ "$STATUS" = "\"running\"" ] && return 0
	fi
	return 1
}

for SERVICE in $SERVICES; do
	if isContainerRunning "$SERVICE" ; then
		docker exec "$SERVICE" "$SCRIPT"
	else
		echo "Container \"$SERVICE\" is not running"
	fi
done
