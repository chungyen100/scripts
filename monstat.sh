#!/bin/bash -x                                                                                                                               # data collection using support's timeseries tool :u

# this is a quick hack to do remote collection
# need to get back and clean up with single node tasks

TNAME=$1
__delay=$2
__duration=$3
__host=$4

bg_procs=""

mongo --eval "while(true) {print(JSON.stringify(db.serverStatus())); sleep(1000*${__delay})}" ${__host} > ss_$TNAME.${__host}.log &
bg_procs="$! $bg_procs"
ssh ec2-user@${__host} "iostat -k -t -x ${__delay}" > iostat_$TNAME.${__host}.log &
bg_procs="$! $bg_procs"
cat ~/scripts/sysmon.py | ssh ec2-user@${__host} python - ${__delay} > sysmon_$TNAME.${__host}.log &
bg_procs="$! $bg_procs"

sleep ${__duration}
trap 'kill $bg_procs' EXIT




