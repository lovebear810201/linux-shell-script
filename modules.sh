## modules.sh

[root@bf-dev-152 sre]# cat modules.sh
#!/bin/bash
# ray
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
