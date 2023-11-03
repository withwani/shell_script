#!/usr/bin/bash -x
# which bash

export LANG=ko_KR.UTF-8

START_MODE=$1
TEST_MODE=$2

if [ "$START_MODE" == "restart" ]; then
    pm2 reload ecosystem.config.json
else
    pm2 start ecosystem.config.json
fi

if [ "$TEST_MODE" == "quan" ]; then
    python3 ./custom_modules/py_subscriber/subscriber_using_multi_thread_quan.py
else
    python3 ./custom_modules/py_subscriber/subscriber_using_multi_thread.py
fi
