#!/bin/sh -ex

cd /opt/cf-proxy
java -jar cf-proxy-2.0.0-SNAPSHOT.jar &
PID=$!
sleep 2

netstat -ln | grep 5682
netstat -ln | grep 8080

kill $PID
