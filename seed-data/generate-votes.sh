#!/bin/sh

# Use the correct service name from docker-compose
TARGET_HOST="http://vote-app:8080"

# create 3000 votes (2000 for option a, 1000 for option b)
ab -n 1000 -c 50 -p posta -T "application/x-www-form-urlencoded" $TARGET_HOST/
ab -n 1000 -c 50 -p postb -T "application/x-www-form-urlencoded" $TARGET_HOST/
ab -n 1000 -c 50 -p posta -T "application/x-www-form-urlencoded" $TARGET_HOST/

