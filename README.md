# Simple Samba Shares

## Requirements
Docker Remote API v1.14 (Docker v1.2.x) or greater is required to discover mounted volumes.

## Usage
Launch a container from the image with `/var/run/docker.sock` mounted as `/docker.sock`.
Any additional mounts will be exposed as public writeable Samba shares, unless mounted
read only, which makes them shared as read-only as well.
Shares will be named from last part of mapped path.

E.g:
```
$ docker run --rm -it \
	-p 445:445 \
	-v /var/run/docker.sock:/docker.sock \
	-v /storage/some_files:/shares/read_only:ro \
	-v /storage/more_files:/shares/writeable \
	neochrome/samba
```
Will result in two shares `read_only` (read only) and `writeable`.

The smbd daemon will force user/group to root for convinient access to files.
