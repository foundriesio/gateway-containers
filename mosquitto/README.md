# Mosquitto for MQTT

## Build the container

```
docker build -t mosquitto --force-rm -f Dockerfile .
```

## Run the container

Create a local mosquitto config file with generic credentials and relevant channel info:

```
connection #connection-name
address #url:#port
remote_username #username
remote_password #password
try_private false
start_type automatic
bridge_attempt_unsubscribe false
notifications false
connection_messages true
log_dest stdout

# Device management subscriptions
topic iotdm-1/type/+/id/# in 1 "" ""

# Gateway notifications
topic iot-2/type/+/id/+/notify in 1 "" ""

# Commands and events
topic iot-2/type/+/id/+/cmd/+/fmt/+ in "" ""
topic iot-2/type/+/id/+/evt/+/fmt/+ out "" ""

# Device management publications
topic iotdevice-1/type/+/id/# out 1 "" ""
```

Then run the containiner volume mounting your mosquitto config file:

```
docker run --restart=always -d -t --net=host --read-only -v /path/to/mosquitto.conf:/etc/mosquitto/conf.d/mosquitto.conf --name mosquitto mosquitto
```

## Run the pre-built container

```
docker run --restart=always -d -t --net=host --read-only -v /path/to/mosquitto.conf:/etc/mosquitto/conf.d/mosquitto.conf --name mosquitto opensourcefoundries/mosquitto:latest
```
