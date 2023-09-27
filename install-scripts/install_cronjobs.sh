#!/bin/bash

mkdir -p /root/cronjob_logs
./run_all_cronjobs.sh
envsubst < cronjobs/crontab | crontab

