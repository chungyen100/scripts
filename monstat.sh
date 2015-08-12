#!/bin/bash                                                                                                                                 # data collection using support's timeseries tool 

TNAME=$1
__delay=$2
__duration=$3

MONGO="~/mongo/bin/mongo"

bg_procs=""

eval "$MONGO --eval 'while(true) {print(JSON.stringify(db.serverStatus())); sleep(1000*$__delay)}'" > ss_$TNAME.log &
bg_procs="$! $bg_procs"
iostat -k -t -x ${__delay} > iostat_$TNAME.log &
bg_procs="$! $bg_procs"
python ~/scripts/sysmon.py ${__delay} > sysmon_$TNAME.log &
bg_procs="$! $bg_procs"


sleep ${__duration}
trap 'kill $bg_procs' EXIT




