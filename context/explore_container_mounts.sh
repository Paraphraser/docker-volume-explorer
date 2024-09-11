#!/usr/bin/env bash

echo -e "\n\nContainer is running as $CONTAINER"

# process the contents of the /internal directory
ls -1d /internal/* | while read P ; do

	# is this entry a target (as in "mount mountpoint target")?
	if [[ $(mountpoint "$P") == *"is a mountpoint" ]] ; then
	
		# fetch the mountpoint (again, as in "mount mountpoint target)
		SOURCE=$(findmnt --mountpoint "$P" | grep -v "^TARGET" | cut -d " " -f 2)
		# report
		echo "$P is a mount point target for $SOURCE"

	else

		# not a mountpoint target
		echo "$P exists inside the container but is not a mount point target"

	fi

	# the entry may be either a directory or a file
	if [ -d "$P" ] ; then

		# it's a directory
		tree -apug --noreport "$P" | sed -e "s/^/  /"

	else

		# it's a file
		ls -l "$P"

	fi

	# spacer
	echo "------------------------------------------------------"

done
