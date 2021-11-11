FROM alpine:3.13

RUN apk add --no-cache bash dovecot dovecot-pgsql
COPY conf /etc/dovecot
COPY entrypoint.sh /entrypoint.sh
VOLUME ["/var/spool/dovecot"]
EXPOSE 25
ENTRYPOINT ["/entrypoint.sh"]
