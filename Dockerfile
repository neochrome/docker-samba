# vim: ft=dockerfile
FROM alpine:3.2
MAINTAINER Johan Stenqvist <johan@stenqvist.net>
LABEL Description="Simple Samba Shares"

RUN apk --update add \
		curl \
		samba \
	&& curl -L https://get.docker.com/builds/Linux/x86_64/docker-1.9.1.tgz | gunzip | tar -xvf - \
	&& curl -L https://github.com/stedolan/jq/releases/download/jq-1.5/jq-linux64 -o /bin/jq \
		&& chmod +x /bin/jq \
	&& curl -L https://github.com/neochrome/jt/releases/download/v0.1.3/jt-linux-amd64 -o /bin/jt \
		&& chmod +x /bin/jt \
	&& apk del curl \
	&& rm -rf /var/cache/apk/*

COPY . /
ENV DOCKER_HOST='unix:///docker.sock'
EXPOSE 445
CMD ./run.sh
