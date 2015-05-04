#!/bin/bash
experimentName="experiment1";

i=0;
while [ $i -lt 3 ]; do
	ofile=${experimentName}_$i.txt;
	killall mongod
	sleep 10
	rm -r ~/data/testdb
	mkdir -p ~/data/testdb
	# ~/scripts/known_state.sh
	numactl --interleave=all ~/mongo/bin/mongod --dbpath ~/data/testdb --logpath ~/data/testdb/mptest.log --storageEngine wiredTiger --syncdelay 57600 --fork
	for f in $( ls testcases/*.js ); do
		fname=${f%.js}
		fname=${fname##*/}
		# echo "Starting test $fname at $(date)" | tee -a $ofile
		(time numactl --interleave=all python ~/mongo-perf/benchrun.py -f $f --writeCmd true --nodyno --mongo-repo-path ~/mongo/bin/mongo-master -s ~/mongo/bin/mongo -l ${experimentName}_${i}_$fname --rport 27117 -t 1 4 8 16 32 64 96 --trialCount 7 --testFilter "['sanity','daily']") 2>&1 | tee -a $ofile
		#(time numactl --interleave=all python ~/mongo-perf/benchrun.py -f $f --writeCmd true --nodyno --mongo-repo-path ~/mongo/bin/mongo-master -s ~/mongo/bin/mongo -l mptest${i}_$fname --rport 27117 -t 1 4 8 16 32 64 96 --trialCount 7 --testFilter "['sanity','daily']") | tee -a $ofile
		printf "\n\n\n\n" | tee -a $ofile 
	done
	i=$(($i+1))
done

