FROM alpine:3.2
MAINTAINER Luciano Glorioso <lucianoglorioso@gmail.com>

RUN apk add -U bash openjdk7-jre python supervisor && \
    rm -rf /var/cache/apk/* && \
    mkdir /opt && \
    wget -q -O - http://apache.arvixe.com/storm/apache-storm-0.10.0/apache-storm-0.10.0.tar.gz | tar -xzf - -C /opt && \
    mv /opt/apache-storm-0.10.0 /opt/storm && \
    addgroup -g 999 storm && \
    adduser -D  -G storm -s /bin/false -u 999 storm

ENV STORM_HOME /opt/storm

# Creating storm dist folder
RUN mkdir /opt/storm/data

# Adding storm related configurations
COPY ./storm-config/storm.yaml /opt/storm/conf/storm.yaml

# Adding supervisord related configurations
COPY ./supervisord-config/supervisord.conf /etc/supervisord.conf
COPY ./supervisord-config/storm-nimbus.conf /etc/supervisor.d/storm-nimbus.conf

COPY ./bootstrap.sh /home/storm/bootstrap.sh

RUN chmod ugo+x /home/storm/bootstrap.sh

EXPOSE 8080 2003 2006 2008 3773 3772 6380 6627
ENTRYPOINT ["/home/storm/bootstrap.sh"]
