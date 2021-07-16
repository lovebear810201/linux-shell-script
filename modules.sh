## modules.sh

[root@bf-dev-152 sre]# cat modules.sh
#!/bin/bash
# ray and mars
# 2020-8-3 init version: start all rd modules

array_rd_modules=(
  "hierarchy-1.0.jar:cd /opt/gm/hierarchy; ./start.sh" #8021
  "auth-1.0.jar:cd /opt/gm/auth;./start.sh" #8017
  "pay-1.0.jar:cd /opt/gm/pay;./start.sh" #8012
  "admin-1.0.jar:cd /opt/gm/admin;./start.sh" #8014
  "activity-1.0.jar:cd /opt/gm/activity;./start.sh" #8015
  "user-1.0.jar:cd /opt/gm/user;./start.sh"  #8011
  "file-manager-1.0.jar:cd /opt/gm/file-manager;./start.sh " #8019
  "job-1.0.jar:cd /opt/gm/job;./start.sh" #8020
  "server.port=8016:cd /opt/gm/gateway;./admin.sh start" #8016
  "server.port=8018:cd /opt/gm/gateway;./member.sh start" #8018
)


