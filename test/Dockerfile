FROM  alpine:latest
MAINTAINER Valery Yurchenko <vyurchenko1986@gmail.com>

ENV TZ=Europe/Kiev

RUN apk update && upgrade && \
    apk add --no-cache squid=4.13-r0 apache2-utils  \
    ln -snf /usr/share/zoneinfo/$TZ /etc/localtime && echo $TZ > /etc/timezone  \
    apk add --update tzdata \
    rm -rf /tmp/* /var/tmp/* /var/cache/apk/* /var/cache/distfiles/*

EXPOSE 3128/tcp
