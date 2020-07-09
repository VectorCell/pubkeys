#!/bin/bash


DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd )"

# will only generate a key if one is not already present at ~/.ssh/id_rsa
"$DIR/keygen"

cd "$DIR/keys"

KEYDIR="$HOME/.ssh/keys"
if [ ! -d "$KEYDIR" ]; then
	mkdir "$KEYDIR"
fi
chmod 700 "$KEYDIR"

cp ~/.ssh/id_rsa.pub $HOSTNAME.pub
git add $HOSTNAME.pub

for key in $(ls); do
	if [ -e "$KEYDIR/$key" ]; then
		if [ "$(md5sum $key | colrm 33)" == "$(md5sum $KEYDIR/$key | colrm 33)" ]; then
			continue
		fi
		echo "removing old public key $key from $KEYDIR"
		rm "$KEYDIR/$key"
	fi
	echo "adding new public key $key to $KEYDIR"
	cp "$key" "$KEYDIR/$key"
done

echo "adding all keys in $KEYDIR to authorized_keys"
cd "$KEYDIR"
cd ..

find "$KEYDIR" -name "*.pub" | xargs cat > authorized_keys
