#!/bin/bash
# braindead script to kick off mongod for testing cap-1442

# get to a known state
# disable ASLR (Address Space Layout Randomization)
sudo echo 0 > /proc/sys/kernel/randomize_va_space
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
