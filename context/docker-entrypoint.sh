#!/bin/bash
set -e

SCRIPT=$(basename "$0")

# default to false if undefined
SELF_REPAIR=${SELF_REPAIR:-false}

if [ "$SELF_REPAIR" = "true" ] ; then

	# log entry
	echo "$SCRIPT $(date) begin self-repair for $CONTAINER"

	# vol7 and vol8 are NOT mentioned in the Dockerfile. They ARE
	# mentioned on the RHS of the volumes: clause in the supplied
	# service definition so, all other things being equal, they
	# will be created by docker-compose as directories.
	# 
	# Now, assume the user is experimenting with the service definition.
	# It's possible that vol7/8 will be omitted and/or mapped as files.
	
	# These lines deal with those possibilities and permit the user to
	# observe self-repair/non-self-repair differences. So in a self-
	# repair situation, if vol7/vol8 are omitted then they will be
	# created as directories
	for F in vol7 vol8 ; do
		if [ ! -e "/internal/$F" ] ; then
			mkdir -pv "/internal/$F"
		fi
	done

	# replace any missing files (-a preserves ownership & permissions
	# AND is recursive, -v is verbose and logs actions, =none is a
	# no-overwrite aka no-clobber option)
	cp -av --update=none /internal-cache/* /internal

	# log entry
	echo "$SCRIPT $(date) end self-repair for $CONTAINER"

else

	# log entry
	echo "$SCRIPT $(date) bypassing self-repair for $CONTAINER"

fi

exec "$@"
