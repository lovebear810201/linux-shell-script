##  rss-mod.sh

[root@bf-dev-152 sre]# cat kafkaclean.sh
#!/bin/bash
# 2020-8-11 ray
# init version: clean kafka/zookeeper log store in /tmp


rm -rf /tmp/kafka-logs/
rm -rf /tmp/zookeeper/
