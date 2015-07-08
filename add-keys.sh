#!/bin/bash

cd keys

keydir="$HOME/.ssh/keys"
if [ ! -d "$keydir" ]; then
	mkdir "$keydir"
fi

for key in $(ls); do
	if [ -e "$keydir/$key" ]; then
		if [ "$(md5sum $key | colrm 33)" == "$(md5sum $keydir/$key | colrm 33)" ]; then
			continue
		fi
		echo "removing old public key $key from $keydir"
		rm "$keydir/$key"
	fi
	echo "adding new public key $key to $keydir"
	cp "$key" "$keydir/$key"
done

echo "adding all keys in $keydir to authorized_keys"
cd "$keydir"
cd ..
cat $keydir/*.pub > authorized_keys

