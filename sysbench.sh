#!/bin/bash

# get to a known state
~/scripts/known_state.sh

rm -r /mnt/data/db
mkdir -p /mnt/data/db

#numactl --physcpubind=0-23 --interleave=all ~/mongo/bin/mongod --dbpath /mnt/cap-1442/single/data/db --logpath=/mnt/cap-1442/single/data/cap-1442.log --storageEngine wiredTiger --syncdelay 57600 --fork
numactl --interleave=all ~/mongo/bin/mongod --dbpath /mnt/data/db --logpath=/mnt/data/db/sysbench.log --storageEngine wiredTiger --fork
#numactl --interleave=all ~/mongo/bin/mongod --dbpath /mnt/data/db --logpath=/mnt/data/db/sysbench.log --fork

numactl --interleave=all ~/sysbench-mongodb/run.simple.bash ~/sysbench-mongodb/config.bash


