FROM inclusivedesign/java:openjdk-7

ENV COUCHDB_LUCENE_VERSION 1.0.2

RUN yum -y install maven tar \
 && mkdir /tmp/couchdb-lucene \
 && curl -L https://github.com/rnewson/couchdb-lucene/archive/v${COUCHDB_LUCENE_VERSION}.tar.gz | tar --strip-components=1 -xzC /tmp/couchdb-lucene/ \
 && cd /tmp/couchdb-lucene \
 && mvn \
 && tar -xzf target/couchdb-lucene-${COUCHDB_LUCENE_VERSION}-dist.tar.gz -C /opt/ \
 && ln -sf /opt/couchdb-lucene-${COUCHDB_LUCENE_VERSION} /opt/couchdb-lucene \
 && mkdir /opt/couchdb-lucene/{indexes,logs} \
 && chown nobody /opt/couchdb-lucene/{indexes,logs} \
 && rm -rf /tmp/couchdb-lucene /root/.m2 \
 && yum -y autoremove maven \
 && yum clean all \
 && sed -e "s/host=localhost/host=0.0.0.0/" -i /opt/couchdb-lucene/conf/couchdb-lucene.ini

# Supervisor will run the couchdb-lucene process with the 'nobody' account
# privileges
COPY couchdb_lucene.ini /etc/supervisord.d/couchdb_lucene.ini

COPY start.sh /usr/local/bin/start.sh

RUN chmod 755 /usr/local/bin/start.sh

EXPOSE 5985

# The DB_PORT_5984_TCP_ADDR and DB_PORT_5984_TCP_PORT environment variables are
# used here to point to a CouchDB instance. They need to be declared when using
# 'docker run...' otherwise defaults of localhost:5984 are used
ENTRYPOINT ["/usr/local/bin/start.sh"]
