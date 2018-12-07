#!/bin/sh -ex

nginx

apk add --no-cache curl
curl http://localhost | grep "Welcome to nginx!"
