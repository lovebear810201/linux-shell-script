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
