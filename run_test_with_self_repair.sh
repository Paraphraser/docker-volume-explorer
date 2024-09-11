#!/usr/bin/env bash

SCRIPT=$(basename "$0")
SERVICES="test1 test2"
SELF_REPAIR=${1:-false}

[ ! -f ".env" ] && echo "TZ=$(cat /etc/timezone)" >.env

case "$SELF_REPAIR" in

	"false" | "true" )
		./reset.sh
		export SELF_REPAIR
		docker-compose up --build -d
		docker image prune -f
		for SERVICE in $SERVICES ; do
			docker logs "$SERVICE"
		done
	;;

	*)
		echo "Usage: $SCRIPT {false|true}"
		exit 1
	;;

esac
