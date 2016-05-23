FROM vsense/baseimage:alpine

MAINTAINER vSense <docker@vsense.fr>

ENV BRANCH master

RUN apk add --update \
    git \
    python \
    unrar \
    zip \
    supervisor \
    py-lxml \
    py-openssl \
    && git clone -b $BRANCH --single-branch https://github.com/RuudBurger/CouchPotatoServer.git /couchpotato  \
    && mkdir /config \
    && mkdir /downloads \
    && adduser -D -h /couchpotato -s /sbin/nologin -u 5001 couchpotato \
    && chown -R couchpotato:couchpotato /couchpotato /config /downloads \
    && rm -rf /var/cache/apk/*

COPY supervisord-couchpotato.ini /etc/supervisor.d/supervisord-couchpotato.ini

VOLUME /config /downloads

EXPOSE 5050

CMD ["supervisord", "-c", "/etc/supervisord.conf", "-n"]
