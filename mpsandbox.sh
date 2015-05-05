#!/bin/bash
experimentName="sbox";

i=0;
while [ $i -lt 1 ]; do
    # Let's start with the wiredTiger tests
    ofile=wt_${experimentName}_$i.txt;
	killall mongod
	sleep 10
	rm -r ~/data/testdb
	mkdir -p ~/data/testdb
	~/scripts/known_state.sh
	echo "numactl --interleave=all ~/mongo/bin/mongod --dbpath ~/data/testdb --logpath ~/data/testdb/mptest.log --storageEngine wiredTiger --syncdelay 57600 --fork" | tee -a $ofile 
	numactl --interleave=all ~/mongo/bin/mongod --dbpath ~/data/testdb --logpath ~/data/testdb/mptest.log --storageEngine wiredTiger --syncdelay 57600 --fork
    sleep 10
	for f in $( ls testcases/*.js ); do
	    fname=${f%.js}
		fname=${fname##*/}
		echo "(time numactl --interleave=all stdbuf -o L python ~/mongo-perf/benchrun.py -f $f --writeCmd true --nodyno --mongo-repo-path ~/mongo/bin/mongo-master -s ~/mongo/bin/mongo -t 1 4 8 16 32 64 96 --trialCount 7 --testFilter "['sanity','daily']") 2>&1 | tee -a $ofile" | tee -a $ofile
		(time numactl --interleave=all stdbuf -o L python ~/mongo-perf/benchrun.py -f $f --writeCmd true --nodyno --mongo-repo-path ~/mongo/bin/mongo-master -s ~/mongo/bin/mongo -t 1 4 8 16 32 64 96 --trialCount 7 --testFilter "['sanity','daily']") 2>&1 | tee -a $ofile | tee -a $ofile
		printf "\n\n\n\n" | tee -a $ofile 
	done

    # Now do the mmapv1 tests 
    ofile=mmap_${experimentName}_$i.txt;
	killall mongod
	sleep 10
	rm -r ~/data/testdb
	mkdir -p ~/data/testdb
	~/scripts/known_state.sh
	echo "numactl --interleave=all ~/mongo/bin/mongod --dbpath ~/data/testdb --logpath ~/data/testdb/mptest.log --storageEngine mmapv1 --syncdelay 57600 --fork" | tee -a $ofile 
	numactl --interleave=all ~/mongo/bin/mongod --dbpath ~/data/testdb --logpath ~/data/testdb/mptest.log --storageEngine mmapv1 --syncdelay 57600 --fork
    sleep 10
	for f in $( ls testcases/*.js ); do
	    fname=${f%.js}
		fname=${fname##*/}
		echo "(time numactl --interleave=all stdbuf -o L python ~/mongo-perf/benchrun.py -f $f --writeCmd true --nodyno --mongo-repo-path ~/mongo/bin/mongo-master -s ~/mongo/bin/mongo -t 1 4 8 16 32 64 96 --trialCount 7 --testFilter "['sanity','daily']") 2>&1 | tee -a $ofile" | tee -a $ofile
		(time numactl --interleave=all stdbuf -o L python ~/mongo-perf/benchrun.py -f $f --writeCmd true --nodyno --mongo-repo-path ~/mongo/bin/mongo-master -s ~/mongo/bin/mongo -t 1 4 8 16 32 64 96 --trialCount 7 --testFilter "['sanity','daily']") 2>&1 | tee -a $ofile | tee -a $ofile
		printf "\n\n\n\n" | tee -a $ofile 
	done
	i=$(($i+1))
done

