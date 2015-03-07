#!/bin/bash                                                                                                                                                                
# data collection using support's timeseries tool 

TS="/home/ec2-user/support-tools/timeseries"
__delay=1
tdir="/home/ec2-user/scripts" # test directory where will store the data

MONGO="/home/ec2-user/mongo/bin/mongo"

bg_procs=""

eval "$MONGO --eval 'while(true) {print(JSON.stringify(db.serverStatus())); sleep(1000*$__delay)}'" >$tdir/ss.log &
echo "mongo $!"
bg_procs="$! $bg_procs"
iostat -k -t -x ${__delay} ${device} >$tdir/iostat.log &
echo "iostat $!"
bg_procs="$! $bg_procs"
python $TS/sysmon.py $__delay >$tdir/sysmon.log &
echo "sysmon $!"
bg_procs="$! $bg_procs"
python $TS/gdbmon.py $(pidof mongod) $__delay >$tdir/gdbmon.log &
bg_procs="$! $bg_procs"

echo $bg_procs

sleep 50
trap 'kill $bg_procs' EXIT
#kill $pg_procs
#trap 'kill $(jobs -p)' EXIT



