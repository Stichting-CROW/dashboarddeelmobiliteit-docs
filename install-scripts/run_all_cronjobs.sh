echo "Run cronjobs manually first time"
export ENVFILE=.env && cronjobs/run-od-matrix-aggregator.sh >> /root/cronjob_logs/od-matrix-aggregator.log
export ENVFILE=.env && cronjobs/run-dd-daily-report-aggregator.sh >> /root/cronjob_logs/dd-daily-report-aggregator.log
