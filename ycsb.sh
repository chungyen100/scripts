#!/bin/bash
function clean_start {
    killall -w mongod
    sleep 10
    rm -rf ~/db/testdb
    mkdir -p ~/db/testdb
    ~/scripts/known_state.sh
    ulimit -c unlimited
}

function link_and_start_mongod {
    rm ~/mongo
    ln -s $1 ~/mongo
    numactl --interleave=all ~/mongo/bin/mongod --dbpath ~/db/testdb --logpath ~/logs/mongod.log --storageEngine wiredTiger --master --fork 
}

i=1;
while [ $i -lt 8 ]; do
   clean_start
   sleep 10
   link_and_start_mongod mongodb_ff6326e
   sleep 10
   (stdbuf -o L ~/YCSB/ycsb-mongodb/bin/ycsb load mongodb -s -P ~/YCSB/ycsb-mongodb/workloads/workloadc  -threads 64 2>&1 | tee load.txt) &
   ~/scripts/monstat_local.sh load 1 60
   wait 
   sleep 10 
   (stdbuf -o L ~/YCSB/ycsb-mongodb/bin/ycsb run mongodb -s -P ~/YCSB/ycsb-mongodb/workloads/workloadc  -threads 64 2>&1 | tee run.txt) &
   ~/scripts/monstat_local.sh run 1 60
   wait
   mkdir good_${i}
   mv *.txt good_${i}
   mv *.log good_${i}

   sleep 5
   
   clean_start
   sleep 10
   link_and_start_mongod mongodb_ae9df7f
   sleep 10
   (stdbuf -o L ~/YCSB/ycsb-mongodb/bin/ycsb load mongodb -s -P ~/YCSB/ycsb-mongodb/workloads/workloadc  -threads 64 2>&1 | tee load.txt) &
   ~/scripts/monstat_local.sh load 1 60
   wait 
   sleep 10 
   (stdbuf -o L ~/YCSB/ycsb-mongodb/bin/ycsb run mongodb -s -P ~/YCSB/ycsb-mongodb/workloads/workloadc  -threads 64 2>&1 | tee run.txt) &
   ~/scripts/monstat_local.sh run 1 60
   wait
   mkdir bad_${i}
   mv *.txt bad_${i}
   mv *.log bad_${i}

   sleep 5
   i=$(($i+1))
done

