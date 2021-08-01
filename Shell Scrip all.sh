Shell Scrip

## modules.sh
## modules.sh

[root@bf-dev-152 sre]# cat modules.sh
#!/bin/bash
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


#start all modules
start_all_modules() {
echo -e "\nfunction: start_all_modules\n"
  for var_data in "${array_rd_modules[@]}"; do
    var_rd_module=$(echo ${var_data} | awk -F":" '{print $1}')
    var_start_cmd=$(echo ${var_data} | awk -F":" '{print $2}')

    #echo ${var_rd_module} ${var_start_cmd}
    var_module_pid=$(pgrep -f ${var_rd_module})
    if [ -z "${var_module_pid}" ]; then
      #echo "${var_rd_module} pid not found, fake start  ${var_start_cmd}"
      eval ${var_start_cmd}
    else
      echo -e "pid is ${var_module_pid}\tmodule: ${var_rd_module}"
    fi
  done
}
#end- start all modules

#list all modules
list_all_modules() {
echo -e "\nfunction: list_all_modules\n"
  for var_data in "${array_rd_modules[@]}"; do
    var_rd_module=$(echo ${var_data} | awk -F":" '{print $1}')

    var_module_pid=$(pgrep -f ${var_rd_module})
    if [ -z "${var_module_pid}" ]; then
      echo -e "stopped\t${var_rd_module}"
      #eval ${var_start_cmd}
    else
      echo -e "${var_module_pid}\t${var_rd_module}"
    fi

  done

}
#end- list all modules

#kill al modules
kill_all_modules() {
echo -e "\nfunction: kill_all_modules\n"
  for var_data in "${array_rd_modules[@]}"; do
    var_rd_module=$(echo ${var_data} | awk -F":" '{print $1}')

    var_module_pid=$(pgrep -f ${var_rd_module})
    if [ -z "${var_module_pid}" ]; then
      echo "pid not found, pass kill: ${var_rd_module}"
      #eval ${var_start_cmd}
    else
      echo -e "pid is ${var_module_pid}, kill it!!\t (${var_rd_module})"
      kill -9 ${var_module_pid}
    fi
  done
}
#end- kill all modules

#main section
if [ -z ${1} ]; then #if $1 is null then
  echo -e '!!!error!!!\nusage: modules.sh function, function could be start/kill/list.'
  exit 1
fi

echo -e "\nmodules.sh >> parameter=${1}\n"

case ${1} in
start)
  start_all_modules
  /opt/sre/stormda.sh start
  ;;
kill)

  kill_all_modules
  /opt/sre/stormda.sh kill
  ;;
restart)
  kill_all_modules
  start_all_modules
  /opt/sre/stormda.sh kill
  /opt/sre/stormda.sh start
  ;;
list)
  list_all_modules
  /opt/sre/stormda.sh list
  ;;
*)
  echo "parameter not supported"
  ;;
esac



## stormda.sh
[root@bf-dev-152 sre]# cat stormda.sh
#!/bin/bash
# 2020-8-11 ray
# init version: cp dadaanalyze to storm-nimbus start/list or kill topo
# 0.1  version: add var for gcp path & env (var_da, var_env



var_da="/home/deploymgr/storm/dataAnalyze-1.0.jar"
#var_da="/home/deploymgr_gcp/storm/dataAnalyze-1.0.jar" #gcp
var_env="bf_dev"
#var_env="bf_qat" #gcp

#main section
if [ -z ${1} ]; then #if $1 is null then
  echo -e '!!!error!!!\nusage: stormda.sh function, function could be start/kill/list.'
  exit 1
fi

echo -e "\nstormda.sh >> parameter=${1}\n"

case ${1} in
start)
docker cp "${var_da}" storm_nimbus:/opt/apache-storm-1.2.2/
#docker cp /home/deploymgr/storm/dataAnalyze-1.0.jar storm_nimbus:/opt/apache-storm-1.2.2/

docker exec -i storm_nimbus bash -c "storm jar /opt/apache-storm-1.2.2/dataAnalyze-1.0.jar com.gm.topology.gamerecord.GameRecordTopo ${var_env} "
docker exec -i storm_nimbus bash -c "storm jar /opt/apache-storm-1.2.2/dataAnalyze-1.0.jar com.gm.topology.activity.ActivityStatTopo ${var_env} "
docker exec -i storm_nimbus bash -c "storm jar /opt/apache-storm-1.2.2/dataAnalyze-1.0.jar com.gm.topology.finance.StatementTopo     ${var_env} "
docker exec -i storm_nimbus bash -c "storm jar /opt/apache-storm-1.2.2/dataAnalyze-1.0.jar com.gm.topology.platform.PlatformStatTopo ${var_env} "

  ;;
kill)
docker exec -i storm_nimbus bash -c "storm kill gameRecordAnalyze -w 5"
docker exec -i storm_nimbus bash -c "storm kill ActivityStatement -w 5"
docker exec -i storm_nimbus bash -c "storm kill FinanceStatement -w 5"
docker exec -i storm_nimbus bash -c "storm kill PlatformStatement -w 5"
  ;;
restart)
  ;;
list)
docker exec -i storm_nimbus bash -c "storm list"
  ;;
*)
  echo "parameter not supported"
  ;;
esac



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



##  rss-mod.sh

[root@bf-dev-152 sre]# cat kafkaclean.sh
#!/bin/bash
# 2020-8-11 ray
# init version: clean kafka/zookeeper log store in /tmp


rm -rf /tmp/kafka-logs/
rm -rf /tmp/zookeeper/

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



