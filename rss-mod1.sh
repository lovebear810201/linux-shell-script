##  rss-mod.sh

[root@bf-dev-152 sre]# cat rss-mod.sh
#!/bin/bash
# ray
# 2020-8-20 init version: query info for rd modules

array_rd_modules=(
  "hierarchy-1.0.jar:hierarchy"
  "auth-1.0.jar:auth"
  "pay-1.0.jar:pay"
  "admin-1.0.jar:admin"
  "activity-1.0.jar:activity"
  "user-1.0.jar:user"
  "file-manager-1.0.jar:file_manager"
  "job-1.0.jar:job"
  "server.port=8016:gw_admin"
  "server.port=8018:gw_member"
)

for var_data in "${array_rd_modules[@]}"; do
    var_rd_module=$(echo ${var_data} | awk -F":" '{print $1}')
    var_module_name=$(echo ${var_data} | awk -F":" '{print $2}')
    var_log_filename="/tmp/${var_module_name}.mlog"
    var_module_pid=$(pgrep -f ${var_rd_module})

#echo "module: ${var_module_name} , pid: ${var_module_pid}"

    if [ -z "${var_module_pid}" ]; then
      echo "0"  > ${var_log_filename}
    else
      ps aux | grep " ${var_module_pid} " | grep -v grep | awk '{print $6}' > ${var_log_filename}
 #     ps aux | grep ${var_module_pid} | grep -v grep | awk '{print $6}'
    fi
  done