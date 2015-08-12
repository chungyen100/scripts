#!/bin/bash

i=0;
while [ $i -lt 1 ]; do
    # Let's start with the encrypted tests
    killall mongod
    sleep 10
    rm -rf ~/data/testdb
    mkdir -p ~/data/testdb
    ~/scripts/known_state.sh
    numactl --interleave=all ~/mongo/bin/mongod --dbpath ~/data/testdb --logpath ~/data/testdb/mongod.log --storageEngine wiredTiger --enableEncryption --encryptionKeyFile ~/ese.key --fork
    sleep 10
    (stdbuf -o L ~/YCSB/ycsb-mongodb/bin/ycsb load mongodb -s -P ~/YCSB/ycsb-mongodb/workloads/workload_ese -threads 16 2>&1 | tee ese_load.txt) &
    sleep 30
    ~/scripts/monstat.sh ese_load 1 300
    wait
    (stdbuf -o L ~/YCSB/ycsb-mongodb/bin/ycsb run mongodb -s -P ~/YCSB/ycsb-mongodb/workloads/workload_ese -threads 16 2>&1 | tee ese_run.txt) &
    sleep 30
    ~/scripts/monstat.sh ese_run 1 600
    wait

    # Now do the baseline 
    killall mongod
    sleep 10
    rm -rf ~/data/testdb
    mkdir -p ~/data/testdb
    ~/scripts/known_state.sh
    numactl --interleave=all ~/mongo/bin/mongod --dbpath ~/data/testdb --logpath ~/data/testdb/mongod.log --storageEngine wiredTiger --fork
    sleep 10
    (stdbuf -o L ~/YCSB/ycsb-mongodb/bin/ycsb load mongodb -s -P ~/YCSB/ycsb-mongodb/workloads/workload_ese -threads 16 2>&1 | tee base_load.txt) &
    sleep 30
    ~/scripts/monstat.sh base_load 1 300
    wait 
    (stdbuf -o L ~/YCSB/ycsb-mongodb/bin/ycsb run mongodb -s -P ~/YCSB/ycsb-mongodb/workloads/workload_ese -threads 16 2>&1 | tee base_run.txt) &
    sleep 30 
    ~/scripts/monstat.sh base_run 1 600
    wait
    
    i=$(($i+1))
done
