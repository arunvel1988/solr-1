#!/bin/bash
set -e

for f in /docker-entrypoint-init.d/*; do
  case "$f" in
    *.sh)  echo "$0: running $f"; . "$f" ;;
    *)     echo "$0: ignoring $f" ;;
   esac
   echo
done

chown -R $SOLR_USER. /opt/solr

exec gosu $SOLR_USER /opt/solr/bin/solr start -f "$@"
