# Couchpotato Dockerfile

FROM gliderlabs/alpine

MAINTAINER Kevin Lefevre <klefevre@vsense.fr>

RUN apk-install \
    git \
    python \
    unrar \
    zip \
    supervisor \
    && git clone https://github.com/RuudBurger/CouchPotatoServer.git /couchpotato  \
    && mkdir /config \
    && mkdir /downloads \
    && adduser -D -h /couchpotato -s /sbin/nologin -u 5001 couchpotato \
    && chown -R couchpotato:couchpotato /couchpotato /config /downloads

COPY supervisord-couchpotato.ini /etc/supervisor.d/supervisord-couchpotato.ini

VOLUME /config /downloads

EXPOSE 5050

CMD ["supervisord", "-c", "/etc/supervisord.conf", "-n"]
