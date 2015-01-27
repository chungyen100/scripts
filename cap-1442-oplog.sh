#!/bin/bash
# braindead script to kick off mongod for testing cap-1442

# get to a known state
killall mongod

# clear cache
sudo bash -c "echo 3 > /proc/sys/vm/drop_caches"

#disable transparent huge pages
if [ -e /sys/kernel/mm/transparent_hugepage/enabled ]
then
        echo never | sudo tee /sys/kernel/mm/transparent_hugepage/enabled /sys/kernel/mm/transparent_hugepage/defrag
fi

# if cpufreq scaling governor is present, ensure we aren't in power save (speed step) mode
if [ -e /sys/devices/system/cpu/cpu0/cpufreq/scaling_governor ]
then
        echo performance | sudo tee /sys/devices/system/cpu/cpu*/cpufreq/scaling_governor
fi

rm -r /mnt/cap-1442/oplog
mkdir -p /mnt/cap-1442/oplog/data/db

numactl --physcpubind=0-23 --interleave=all ~/mongo/bin/mongod --dbpath /mnt/cap-1442/oplog/data/db --logpath=/mnt/cap-1442/oplog/data/cap-1442.log --storageEngine wiredTiger --syncdelay 57600 --replSet cap1442 --oplogSize 2048 --fork

sleep 5

~/mongo/bin/mongo ~/scripts/setup_repl.js

sleep 5 

numactl --physcpubind=24-31 --interleave=all python ~/mongo-perf/benchrun.py -f ~/mongo-perf/testcases/*update.js --writeCmd true --nodyno --mongo-repo-path /mnt/mongo-master -s ~/mongo/bin/mongo -l cap-1442-oplog -t 1 4 8 16 24 48 72 96 120 --testFilter "['sanity','daily']"
#numactl --physcpubind=24-31 --interleave=all python ~/mongo-perf/benchrun.py -f ~/mongo-perf/testcases/*insert.js ~/mongo-perf/testcases/*update.js ~/mongo-perf/testcases/*remove.js --writeCmd true --nodyno --mongo-repo-path /mnt/mongo-master -s ~/mongo/bin/mongo -l cap-1442-oplog -t 1 4 8 16 24 48 72 96 120 --testFilter "['sanity','daily']"


