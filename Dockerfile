FROM debian:wheezy
MAINTAINER Stephen Perona <sperona@isitedesign.com>

ENV DEBIAN_FRONTEND noninteractive

# Update package repos.
RUN apt-get update

# Install curl and rsync to help retrieve and move configs.
RUN apt-get install -y curl rsync

# Install java.
RUN apt-get install -y java7-jdk

# Add the tomcat user.
RUN useradd -Mb /usr/local tomcat

# Download tomcat.
RUN curl -o /usr/local/src/tomcat.tar.gz http://mirrors.ibiblio.org/apache/tomcat/tomcat-7/v7.0.59/bin/apache-tomcat-7.0.59.tar.gz

# Extract and move tomcat.
RUN tar -C /usr/local -zxf /usr/local/src/tomcat.tar.gz
RUN mv /usr/local/apache-tomcat-7.* /usr/local/tomcat

# Configure tomcat to run on port 8983.
RUN sed -i s/8080/8983/g /usr/local/tomcat/conf/server.xml

# Set owner and group on tomcat directory.
RUN chown -R tomcat:tomcat /usr/local/tomcat

# Download and unpack Solr.
RUN curl -O http://archive.apache.org/dist/lucene/solr/4.3.1/solr-4.3.1.tgz
RUN tar -zxf solr-4.3.1.tgz

# Copy Solr libraries and configs.
RUN cp solr-4.3.1/dist/solrj-lib/* /usr/local/tomcat/lib/
RUN cp solr-4.3.1/example/resources/log4j.properties /usr/local/tomcat/conf/
RUN cp solr-4.3.1/dist/solr-4.3.1.war /usr/local/tomcat/webapps/solr.war

# Copy up basic solr context and environment config.
COPY solr.xml /usr/local/tomcat/conf/Catalina/localhost/solr.xml

# 
RUN mkdir -p /usr/local/tomcat/solr
RUN cp -r solr-4.3.1/example/solr/collection1/conf /usr/local/tomcat/solr/

# Download apchesolr Drupal module and unpack it.
RUN curl -O http://ftp.drupal.org/files/projects/apachesolr-7.x-1.7.tar.gz
RUN tar -zxf apachesolr-*.tar.gz

# Copy solr config and schema from module and copy up solr cores basic config.
RUN rsync -av apachesolr/solr-conf/solr-4.x/ /usr/local/tomcat/solr/conf/
COPY solr_cores.xml /usr/local/tomcat/solr/solr.xml

# Create directory for drupal cores.
RUN mkdir /usr/local/tomcat/solr/drupal
RUN cp -r /usr/local/tomcat/solr/conf /usr/local/tomcat/solr/drupal/

# Update owner and group on tomcat directory for all the new files.
RUN chown -R tomcat:tomcat /usr/local/tomcat

# Expose port for Solr.
EXPOSE 8983

# Copy up start up script.
ADD start.sh /start.sh
RUN chmod 755 /start.sh

CMD ["/bin/bash", "start.sh"]