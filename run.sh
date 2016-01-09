#!/bin/sh
set -e
cat > /smb.conf <<EOT
[global]
bind interfaces only = yes
interfaces = lo eth0
load printers = no
disable spoolss = yes
browseable = yes
read only = no
guest ok = yes
guest only = yes
create mask = 0644
directory mask = 0755
map to guest = bad user
guest account = nobody
force user = root
force group = root
EOT
for p in $(lsdvol --docker-socket /docker.sock); do
	[[ "$p" = "/docker.sock" ]] && continue
	cat >> /smb.conf <<EOT

[$(basename $p)]
path = $p
EOT
done

smbd \
	--foreground \
	--log-stdout \
	--configfile /smb.conf
