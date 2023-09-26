#!/bin/bash

mkdir -p /root/cronjob_logs
envsubst < cronjobs/crontab | crontab
