#!/bin/bash
# format : Hostname, DateTime, CPU%, Mem%, Disk%, Network connections, ActiveUsers

R_HOSTNAME=$(hostname)
R_DATE=$(date +"%F %T")
R_CPU_PCT_USED=$(top -b -n1 | grep Cpu | awk '{print $2}')
R_MEM_PCT_USED=$(free | grep Mem | awk '{print $3/$2 *100.0}')
R_DISK_PCT_USED=$(df -PTh | grep " /$" | awk '{print $6}' | sed 's/%//g')   # note, only looking for the main / mount
R_NET_CONNS=$(ss -tp | grep ESTAB | wc -l)  # does a basic TCP connections count
R_ACTIVE_USERS=$(who | wc -l)

echo "Hostname, DateTime, CPU%, Mem%, Disk%"
echo "$R_HOSTNAME, $R_DATE, $R_CPU_PCT_USED, $R_MEM_PCT_USED, $R_DISK_PCT_USED, $R_NET_CONNS, $R_ACTIVE_USERS"
