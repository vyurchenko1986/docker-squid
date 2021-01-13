#!/usr/bin/env sh

set -e

SQUID_DATA="squid_data" && \
docker volume create --name $SQUID_DATA && \
docker build -t squid . && \
docker run -d -p 3128:3128 --name=squid --restart=always -v $SQUID_DATA:/etc/squid squid
