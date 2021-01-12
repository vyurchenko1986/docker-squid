FROM  alpine:latest
MAINTAINER Valery Yurchenko <vyurchenko1986@gmail.com>

ENV TZ=Europe/Kiev

RUN apk update && upgrade && \
apk add --no-cache squid=4.13-r0 apache2-utils
RUN ln -snf /usr/share/zoneinfo/$TZ /etc/localtime && echo $TZ > /etc/timezone
RUN apk add --update tzdata
RUN rm -rf /tmp/* /var/tmp/* /var/cache/apk/* /var/cache/distfiles/*
