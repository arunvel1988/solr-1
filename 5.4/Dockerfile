# Apache Solr - http://lucene.apache.org/solr/
#
# docker run -d \
#      --restart on-failure \
#      -p 8983:8983 \
#      --name solr \
#      rmarchei/solr \
#      -m 8g
#

FROM centos:latest
MAINTAINER Ruggero Marchei <ruggero.marchei@daemonzone.net>


ENV JDK_VERSION 8u71-b15

RUN cd /tmp && \
  yum install -y unzip && \
  curl -sLO -b "oraclelicense=accept-securebackup-cookie" http://download.oracle.com/otn-pub/java/jdk/${JDK_VERSION}/jdk-${JDK_VERSION%%-*}-linux-x64.rpm && \
  yum install -y /tmp/jdk-${JDK_VERSION%%-*}-linux-x64.rpm && \
  rm -f /tmp/jdk-${JDK_VERSION%%-*}-linux-x64.rpm && \
  yum clean all -q


ENV GOSU_VERSION 1.7

RUN cd /usr/local/bin \
  && curl -fsSL -o gosu "https://github.com/tianon/gosu/releases/download/$GOSU_VERSION/gosu-amd64" \
  && curl -fsSL "https://github.com/tianon/gosu/releases/download/$GOSU_VERSION/SHA256SUMS" | grep -E 'gosu-amd64$' | sed -e 's/gosu-.*$/gosu/' | sha256sum -c - \
  && chmod +x gosu


ENV SOLR_USER solr
ENV SOLR_UID 8983

RUN groupadd -r $SOLR_USER -o -g $SOLR_UID && \
  useradd -r -u $SOLR_UID -o -g $SOLR_USER -m -d /opt/solr $SOLR_USER


ENV SOLR_VERSION 5.4.1

RUN cd /tmp && \
  curl -s -O http://archive.apache.org/dist/lucene/solr/$SOLR_VERSION/solr-$SOLR_VERSION.tgz && \
  curl -s -O http://archive.apache.org/dist/lucene/solr/$SOLR_VERSION/solr-$SOLR_VERSION.tgz.sha1 && \
  sha1sum -c /tmp/solr-$SOLR_VERSION.tgz.sha1 && \
  tar -C /opt/solr --extract --file /tmp/solr-$SOLR_VERSION.tgz --strip-components=1 && \
  rm -f /tmp/solr-$SOLR_VERSION.tgz* && \
  mkdir -p /opt/solr/server/solr/lib && \
  chown -R $SOLR_USER. /opt/solr


EXPOSE 8983
WORKDIR /opt/solr


RUN mkdir /docker-entrypoint-init.d
COPY docker-entrypoint-init.d/* /docker-entrypoint-init.d/

COPY docker-entrypoint.sh /
RUN chmod +x /docker-entrypoint.sh

ENTRYPOINT ["/docker-entrypoint.sh"]
CMD ["-m", "512m"]
