# shell_script

Shell script 파일 프로젝트

# monitoring crontab setting

```
* * * * * . /home/busmon/war/commuteBus/bin/cron-monitor-host.sh >>/home/busmon/war/commuteBus/logs/cron-monitor_$(date +\%y\%m\%d).log 2>&1
* 1 1 * * . /home/busmon/war/commuteBus/bin/cron-monitor-logrm.sh

```
