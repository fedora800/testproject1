#!/bin/bash
# Input is the remote hostname (Note: ssh keys should have been setup already for password less ssh)

R_HOSTNAME=$1
R_DATE=$(date +"%F %T")
R_CPU_PCT_USED=$(top -b -n1 | grep Cpu | awk '{print $2}')
R_MEM_PCT_USED=$(free | grep Mem | awk '{print $3/$2 *100.0}')
R_DISK_PCT_USED=$(df -PTh | grep " /$" | awk '{print $6}' | sed 's/%//g')   # note, only looking for the main / mount
R_NET_CONNS=$(ss -tp | grep ESTAB | wc -l)  # does a basic TCP connections count
R_ACTIVE_USERS=$(who | wc -l)
STATS_FILE="/tmp/remote_host_stats.csv"

echo "Hostname, DateTime, CPU%, Mem%, Disk%" >> $STATS_FILE
echo "$R_HOSTNAME, $R_DATE, $R_CPU_PCT_USED, $R_MEM_PCT_USED, $R_DISK_PCT_USED, $R_NET_CONNS, $R_ACTIVE_USERS" >> $STATS_FILE
