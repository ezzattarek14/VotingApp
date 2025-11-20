#!/bin/sh
redis-cli -h 127.0.0.1 ping | grep -q PONG

