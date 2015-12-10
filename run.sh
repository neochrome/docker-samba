#!/bin/sh
if [[ ! -e /docker.sock ]]; then
	printf 'Cannot find /docker.sock, is it not mapped?' 1>&2
	exit 1
fi
CONTAINER_ID=$(grep -o '[a-z,0-9]*$' /proc/self/cgroup | head -n 1)

docker inspect $CONTAINER_ID \
	| jq '.[].Mounts|map(select(.Destination != "/docker.sock"))|map({share:.Destination|split("/")[-1],path:.Destination,writeable:.RW})' \
	| jt --template /smb.conf.tmpl > /smb.conf

smbd \
	--foreground \
	--log-stdout \
	--configfile /smb.conf
