#!/bin/bash
# fluentd log watcher
# fluentd tend to stop sending logs when elasticsearch plugin exeeding 10MB
# request payload limit, so we have to restart fluentd when the file-log
# shows "RequestEntityTooLarge" string.

clear

export LANG=C
export LC_ALL=C
export LC_MESSAGES=C

HOSTNAME="${COLLECTD_HOSTNAME:-`hostname -s`}"
INTERVAL="${COLLECTD_INTERVAL:-30}"

while sleep 15; do

  loadLog=$(tail -n 1 /var/log/td-agent/fluentd-agent.log)
  parseLog=$( echo "$loadLog" | grep "RequestEntityTooLarge")

  if [[ -z "$parseLog" ]]; then
    echo -e "`date +%D-%H-%M-%S` fluentd still running"
    echo "collectd.fluentd.$HOSTNAME.status 1 `date +%s`" | nc somehost 2003
  else
    echo -e "`date +%D-%H-%M-%S` fluentd experiece RequestEntityTooLarge!\nTrying to restart fluentd\n"
    supervisorctl restart runfluentdservice
    #/etc/init.d/td-agent restart
    echo "collectd.fluentd.$HOSTNAME.status 0 `date +%s`" | nc somehost 2003
  fi

  parseStack=$( echo "$loadLog" | grep "stacktrace")
  if [[ -z "$parseStack" ]]; then
    echo -e "`date +%D-%H-%M-%S` fluentd still running, no stacktrace"
    echo "collectd.fluentd.$HOSTNAME.status 1 `date +%s`" | nc somehost 2003
  else
    echo -e "`date +%D-%H-%M-%S` fluentd experiece RequestEntityTooLarge!\nTrying to restart fluentd\n"
    supervisorctl restart runfluentdservice
    #/etc/init.d/td-agent restart
    echo "collectd.fluentd.$HOSTNAME.status 0 `date +%s`" | nc somehost 2003
  fi

  is_empty=$(tail -n 1 /var/log/h20/somefile.log | grep $(date +%d/%b/%Y:%H))
  if [[ -z "$is_empty" ]]; then
    echo -e "`date +%D-%H-%M-%S` Apache log is empty!\nTrying to restart Apache\n"
    /usr/local/httpd-openssl-101t/bin/apachectl -k restart
    echo -e "\n$is_empty"
  else
    echo -e "`date +%D-%H-%M-%S` Apache log is not empty \nNo need to restart Apache\n"
    echo "\n$is_empty"
  fi

done
