#!/usr/bin/env sh

set -e

SQUID_DATA="squid_data" && \
docker volume create --name $SQUID_DATA && \
docker build -t squid_test . && \
docker run -d -p 9012:9012 --name=squid --restart=always -v $SQUID_DATA:/etc/squid squid_test
