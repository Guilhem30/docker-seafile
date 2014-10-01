FROM		phusion/baseimage
MAINTAINER	Bertrand RETIF  <bretif@sudokeys.com>

RUN export DEBIAN_FRONTEND=noninteractive && \
    apt-get update && \
    apt-get install -y ca-certificates && \
    apt-get install -y python2.7 python-setuptools python-simplejson python-imaging sqlite3 python-mysqldb

RUN ulimit -n 30000

# Interface the environment
RUN mkdir /opt/seafile
WORKDIR /opt/seafile
RUN curl -L -O https://bitbucket.org/haiwen/seafile/downloads/seafile-server_3.1.7_x86-64.tar.gz
RUN tar xzf seafile-server_*
RUN mkdir -p installed
RUN mkdir -p log
RUN mv seafile-server_* installed

VOLUME /opt/seafile
EXPOSE 10001 12001 8000 8082

# Baseimage init process
ENTRYPOINT ["/sbin/my_init"]

# Seafile daemons
RUN mkdir /etc/service/seafile /etc/service/seahub
ADD seafile.sh /etc/service/seafile/run
ADD seahub.sh /etc/service/seahub/run

ADD download-seafile.sh /usr/local/sbin/download-seafile

# Clean up for smaller image
RUN apt-get clean && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*
