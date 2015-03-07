# "config - {standalone|sharded|replicated}"
# "suite - e.g. sanity, daily, Insert.JustNumIndexedBefore"
# "label - e.g. myTest, defaults to suite name"
# "versions - e.g. 3.0.0-rc8, \"3.0.0-rc7 2.6.8\", default"
# "duration (in seconds) - e.g. 20, default"
# "threads - e.g. 8, \"1,2,4,8\", default"
# "trial count - e.g. 1, default"
# "storage engines - e.g. mmapv1"
# "time series - {true|false}, default"
# "restart for each suite - {true|false}"

/home/ec2-user/scripts/skunkwork3/skunk_uber.sh standalone "'sanity','daily'" HT_5sec_7trial_1 3.0.0 5 "1 2 4 8 16 24 32 48 72 96 120" 7 wiredTiger true false
sleep 60
/home/ec2-user/scripts/skunkwork3/skunk_uber.sh standalone "'sanity','daily'" HT_5sec_7trial_2 3.0.0 5 "1 2 4 8 16 24 32 48 72 96 120" 7 wiredTiger true false
sleep 60
/home/ec2-user/scripts/skunkwork3/skunk_uber.sh standalone "'sanity','daily'" HT_5sec_7trial_3 3.0.0 5 "1 2 4 8 16 24 32 48 72 96 120" 7 wiredTiger true false

