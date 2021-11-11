#!/bin/bash

function log {
  echo $(date) $ME - $@
}

function serviceConf {
  # Substitute configuration
  for VARIABLE in $(env | cut -f1 -d=); do
    VAR=${VARIABLE//:/_}
    sed -i "s={{ $VAR }}=${!VAR}=g" /etc/dovecot/*.conf
  done

  # # Override dovecot configuration
  # if [ -f /overrides/dovecot.cf ]; then
  #   while read line; do
  #     postconf -e "$line"
  #   done < /overrides/dovecot.cf
  #   echo "Loaded '/overrides/dovecot.cf'"
  # else
  #   echo "No extra dovecot settings loaded because optional '/overrides/dovecot.cf' not provided."
  # fi

  # # Include table-map files
  # if ls -A /overrides/*.map 1> /dev/null 2>&1; then
  #   cp /overrides/*.map /etc/dovecot/
  #   postmap /etc/dovecot/*.map
  #   rm /etc/dovecot/*.map
  #   chown root:root /etc/dovecot/*.db
  #   chmod 0600 /etc/dovecot/*.db
  #   echo "Loaded 'map files'"
  # else
  #   echo "No extra map files loaded because optional '/overrides/*.map' not provided."
  # fi
}

function serviceStart {
  serviceConf
  # Actually run dovecot
  log "[ Starting dovecot... ]"
  exec /usr/sbin/dovecot -F
}

#export DOMAIN=${DOMAIN:-"localhost"}
#export MESSAGE_SIZE_LIMIT=${MESSAGE_SIZE_LIMIT:-"50000000"}
#export RELAYNETS=${RELAYNETS:-""}
#export RELAYHOST=${RELAYHOST:-""}

export DB_HOST=${DB_HOST:-"postgres"}
export DB_USER=${DB_USER:-"mailreader"}
export DB_PASSWORD=${DB_PASSWORD:-""}
export DB_DATABASE=${DB_DATABASE:-"mails"}
export MAIL_SPOOL=${MAIL_SPOOL:-"/var/spool/dovecot"}

serviceStart
