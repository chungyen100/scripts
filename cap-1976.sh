#!/bin/bash
# braindead script to kick off mongod for testing cap-1442

# get to a known state
# Kill existing mongod
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

rm -r /mnt/cap-1976
mkdir -p /mnt/cap-1976/data/db

numactl --physcpubind=0-23 --interleave=all ~/mongo/bin/mongod --dbpath /mnt/cap-1976/data/db --logpath=/mnt/cap-1976/data/cap-1976.log --storageEngine wiredTiger --syncdelay 57600 --fork

numactl --physcpubind=24-31 --interleave=all python ~/mongo-perf/benchrun.py -f ~/scripts/tcase.js --writeCmd true --nodyno --mongo-repo-path /mnt/mongo-master -s ~/mongo/bin/mongo -l cap-1442-single -t 2 --testFilter "['sanity','daily']" --trialTime 1



