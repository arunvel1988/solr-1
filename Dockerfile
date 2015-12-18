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


RUN yum install -q -y java-1.8.0-openjdk-headless unzip && \
  yum clean all -q

ENV SOLR_USER solr
ENV SOLR_UID 8983

RUN groupadd -r $SOLR_USER -o -g $SOLR_UID && \
  useradd -r -u $SOLR_UID -o -g $SOLR_USER -m -d /opt/solr $SOLR_USER

ENV SOLR_VERSION 5.4.0

RUN cd /tmp && \
  curl -s -O http://archive.apache.org/dist/lucene/solr/$SOLR_VERSION/solr-$SOLR_VERSION.tgz && \
  curl -s -O http://archive.apache.org/dist/lucene/solr/$SOLR_VERSION/solr-$SOLR_VERSION.tgz.sha1 && \
  sha1sum -c /tmp/solr-$SOLR_VERSION.tgz.sha1 && \
  tar -C /opt/solr --extract --file /tmp/solr-$SOLR_VERSION.tgz --strip-components=1 && \
  rm -f /tmp/solr-$SOLR_VERSION.tgz* && \
  mkdir -p /opt/solr/server/solr/lib && \
  chown -R $SOLR_USER. /opt/solr

# https://cwiki.apache.org/confluence/display/solr/Configuring+Logging
RUN sed --in-place -e 's/^log4j.appender.file.MaxFileSize=4MB$/log4j.appender.file.MaxFileSize=100MB/' /opt/solr/server/resources/log4j.properties

EXPOSE 8983
WORKDIR /opt/solr
USER $SOLR_USER

ENTRYPOINT ["/opt/solr/bin/solr", "start", "-f"]
CMD ["-m", "512m"]
