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
	numactl --interleave=all ~/mongo/bin/mongod --dbpath ~/data/testdb --logpath ~/data/testdb/mptest.log --storageEngine wiredTiger --fork
# numactl --interleave=all ~/mongo/bin/mongod --dbpath ~/data/testdb --logpath ~/data/testdb/mptest.log --storageEngine wiredTiger --enableEncryption --encryptionKeyFile ~/ese.key --fork
    sleep 10
    mkdir ese
    cd ese
    ~/YCSB/ycsb-mongodb/bin/ycsb load mongodb -P ~/YCSB/ycsb-mongodb/workloads/workload_ese
    ~/YCSB/ycsb-mongodb/bin/ycsb run mongodb -P ~/YCSB/ycsb-mongodb/workloads/workload_ese
    
    # Now do the baseline 
    ofile=wt_${experimentName}_baseline_$i.txt;
	killall mongod
	sleep 10
	rm -r ~/data/testdb
	mkdir -p ~/data/testdb
	~/scripts/known_state.sh
	numactl --interleave=all ~/mongo/bin/mongod --dbpath ~/data/testdb --logpath ~/data/testdb/mptest.log --storageEngine wiredTiger --fork
    sleep 10
    ~/YCSB/ycsb-mongodb/bin/ycsb load mongodb -P ~/YCSB/ycsb-mongodb/workloads/workload_ese
    ~/YCSB/ycsb-mongodb/bin/ycsb run mongodb -P ~/YCSB/ycsb-mongodb/workloads/workload_ese
    
    i=$(($i+1))
done
