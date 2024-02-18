#!/bin/bash

SLEEP=30

while true
do
  echo "-----  $(date +%T)  ----"
  top -b -n1 | egrep "USER|kswap"
  PS_KSWAP_CPU_ENTRY=$(top -b -n1 | grep kswap | awk '{print $9}')
  #echo $PS_KSWAP_CPU_ENTRY
  CURR_PCT=$(echo $PS_KSWAP_CPU_ENTRY | awk -F'.' '{print $1}')
  echo "curr=$CURR_PCT  prev=$PREV_PCT"
  if [[ $CURR_PCT -gt $PREV_PCT && $PREV_PCT -gt 30 && $CURR_PCT -gt 30 ]]
  then
    echo "***** killing vscode ****"
    ps aux | grep .vscode-server | awk '{print $2}' | xargs kill
    echo "  show if any not killed - "
    ps aux | grep .vscode-server 
  else
    PREV_PCT=$CURR_PCT
  fi
  sleep $SLEEP
done

