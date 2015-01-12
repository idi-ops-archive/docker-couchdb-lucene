#!/bin/sh -e

DB_PORT_5984_TCP_ADDR=${DB_PORT_5984_TCP_ADDR:-localhost}
DB_PORT_5984_TCP_PORT=${DB_PORT_5984_TCP_PORT:-5984}

sed -e "s/localhost:5984/$DB_PORT_5984_TCP_ADDR:$DB_PORT_5984_TCP_PORT/" -i /opt/couchdb-lucene/conf/couchdb-lucene.ini

supervisord -c /etc/supervisord.conf
