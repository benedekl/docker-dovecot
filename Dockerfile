FROM alpine:3.13

RUN apk add --no-cache bash dovecot dovecot-pgsql dovecot-pop3d dovecot-lmtpd dovecot-pigeonhole-plugin shadow \
    && groupadd -g 1000000 vmail \
    && useradd -s /bin/false -g 1000000 -u 1000000 -d /home/vmail vmail \
    && apk del shadow \
    && rm -rf /var/cache/apk/*
COPY conf /etc/dovecot
COPY entrypoint.sh /entrypoint.sh
VOLUME ["/home/vmail"]
EXPOSE 25
ENTRYPOINT ["/entrypoint.sh"]
