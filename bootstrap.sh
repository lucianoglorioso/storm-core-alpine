#!/bin/bash

echo $IOT_SSH_KEYS  > /home/nimbus/.ssh/authorized_keys

/sbin/service sshd restart

sed -i s/\"nimbus\"/\"$(hostname)\"/ /opt/storm/conf/storm.yaml

for i in $(echo $ZOOKEEPER | tr "," "\n");
 do
    sed -i s/storm.zookeeper.servers:/storm.zookeeper.servers:\\n\ \ \ \-\ \"$i\"/ /opt/storm/conf/storm.yaml;
 done

# Starting supervisord
unlink /tmp/supervisor.sock
/usr/bin/supervisord -c /etc/supervisord.conf
#supervisorctl -s http://localhost:9001 -u admin -p admin1234 start all

tail -f /dev/null
