#!/bin/bash
experimentName="ese_84182ff";

i=0;
while [ $i -lt 1 ]; do
    # Let's start with the encrypted tests
    ofile=wt_${experimentName}_$i.txt;
	killall mongod
	sleep 10
	rm -r ~/data/testdb
	mkdir -p ~/data/testdb
	~/scripts/known_state.sh
#	numactl --interleave=all ~/mongo/bin/mongod --dbpath ~/data/testdb --logpath ~/data/testdb/mptest.log --storageEngine wiredTiger --fork
    numactl --interleave=all ~/mongo/bin/mongod --dbpath ~/data/testdb --logpath ~/data/testdb/mongod.log --storageEngine wiredTiger --enableEncryption --encryptionKeyFile ~/ese.key --fork
    sleep 10
    stdbuf -o L ~/YCSB/ycsb-mongodb/bin/ycsb load mongodb -s -P ~/YCSB/ycsb-mongodb/workloads/workload_ese 2>&1 | tee ese_load.txt
    sleep 10
    stdbuf -o L ~/YCSB/ycsb-mongodb/bin/ycsb run mongodb -s -P ~/YCSB/ycsb-mongodb/workloads/workload_ese 2>&1 | tee ese_run.txt
    
    # Now do the baseline 
    ofile=wt_${experimentName}_baseline_$i.txt;
	killall mongod
	sleep 10
	rm -r ~/data/testdb
	mkdir -p ~/data/testdb
	~/scripts/known_state.sh
	numactl --interleave=all ~/mongo/bin/mongod --dbpath ~/data/testdb --logpath ~/data/testdb/mongod.log --storageEngine wiredTiger --fork
    sleep 10
    stdbuf -o L ~/YCSB/ycsb-mongodb/bin/ycsb load mongodb -s -P ~/YCSB/ycsb-mongodb/workloads/workload_ese 2>&1 | tee base_load.txt
    leep 10
    stdbuf -o L ~/YCSB/ycsb-mongodb/bin/ycsb run mongodb -s -P ~/YCSB/ycsb-mongodb/workloads/workload_ese 2>&1 | tee base_run.txt
    
    i=$(($i+1))
done
