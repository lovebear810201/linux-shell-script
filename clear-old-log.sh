##  clear-old-log.sh
[root@bf-dev-152 sre]# cat clear-old-log.sh
#!/bin/bash
# ray
# 2020-7-23 init version: delete old logs in assign folders
# 2020-9-2 change to function. set log_folder log_patter keep_days_ago to clear old log
# 2020-9-4 add working dir and create folder "logs" it not exist

# crontab>> 0 12 * * * root /opt/sre/clear-old-log.sh &>/dev/null

# 1) log_folder 2) log_pattern 3) keep_days
clean_old_log() {

  var_log_file="logs/clearlog_$(date +"%Y%m%d").log"

  if [ "$#" -ne 3 ]; then
    echo -e "ERROR!! need 3 parameter (log_dir/log_pattern/keep_days).\n got $#, they are: \"$@\"" | tee -a ${var_log_file}
    return
  fi

  var_log_dir="${1}"
  var_log_pattern="${2}"
  var_keep_days="${3}"


  var_cmd_exec_ls="find ${var_log_dir} -type f -mtime +${var_keep_days} -name ${var_log_pattern} | xargs -r ls -alh"
  var_cmd_exec_rm="find ${var_log_dir} -type f -mtime +${var_keep_days} -name ${var_log_pattern} | xargs -r rm -rf"
  ###echo "${var_cmd_exec}"
  echo "########"
  echo "${var_cmd_exec_ls}" | tee -a ${var_log_file}
  #echo "-----"
  eval "${var_cmd_exec_ls}" | tee -a ${var_log_file}
  eval "${var_cmd_exec_rm}"

}

var_work_dir="/opt/sre"
cd ${var_work_dir}

[ ! -d "logs" ] && mkdir logs

clean_old_log /opt/kafka/logs     *.log.* 3
clean_old_log /opt/nacos/bin/logs *.log*  3
clean_old_log /root/logs          *.log.* 3
clean_old_log /opt/nacos/logs/    *.log.* 3

clean_old_log /opt/sentinel-dashboard/logs/csp    *.log.* 3
#clean_old_log /opt/gm/*/logs/      *.gz    30
#clean_old_log /root/nacos         *.log.* 7

clean_old_log /opt/gm/activity/logs     *.gz 30
clean_old_log /opt/gm/auth/logs         *.gz 30
clean_old_log /opt/gm/gateway/logs      *.gz 30
clean_old_log /opt/gm/pay/logs          *.gz 30
clean_old_log /opt/gm/admin/logs        *.gz 30
clean_old_log /opt/gm/file-manager/logs *.gz 30
clean_old_log /opt/gm/job/logs          *.gz 30
clean_old_log /opt/gm/user/logs         *.gz 30

#bigsize check
#find / -type f -size +100M
#find / -type f -size +10M | grep -v proc | grep -v overlay2 | grep -v mysqld| xargs -r ls -alh
# kafka log
# /tmp/kafka-logs
# /tmp/zookeeper/


# docker log clean
##fastdfs
# dfs log (already volume mapping to host)  /data/fastdfs/storage/logs
# dfs log (already volume mapping to host)  /data/fastdfs/tracker/logs
# ngx log /usr/local/nginx/logs
#storm , check supervisord , check /opt/apache-storm-1.2.2/logs/workers-artifacts/
# he is worker


##old style
#array_log_dir=("/opt/kafka/logs"
#  "/opt/nacos/bin/logs"
#  "/root/logs"
#  "/root/nacos"
#  "/opt/nacos/logs/")
#no log in folder /root/nacos , /opt/nacos/bin/logs

#var_keep_days=7
#var_log_file="clear-old-log.log.$(date +'%Y%m%d')"
#var_log_pattern="'*.log.*'"
#
#
#cd /opt/sre/logs/
#echo "#####" >> ${var_log_file}
#echo $(date) >> ${var_log_file}
#echo "=====" >> ${var_log_file}
#
#
#for var_log_dir in "${array_log_dir[@]}"; do
#  var_cmd_exec_ls="find ${var_log_dir} -type f -mtime +${var_keep_days} -name ${var_log_pattern} | xargs -r ls -alh"
#  var_cmd_exec_rm="find ${var_log_dir} -type f -mtime +${var_keep_days} -name ${var_log_pattern} | xargs -r rm -rf"
#  #echo "${var_cmd_exec}"
#  echo "${var_cmd_exec_ls}" | tee -a ${var_log_file}
#  echo "-----"
#  eval "${var_cmd_exec_ls}" | tee -a ${var_log_file}
#  eval "${var_cmd_exec_rm}"
#done
