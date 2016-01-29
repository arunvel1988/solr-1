#!/bin/bash

# https://cwiki.apache.org/confluence/display/solr/Configuring+Logging
sed --in-place -e 's/^log4j.appender.file.MaxFileSize=4MB$/log4j.appender.file.MaxFileSize=100MB/' /opt/solr/server/resources/log4j.properties
