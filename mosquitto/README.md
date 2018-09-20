Eclipse Mosquitto is an open source implementation of a server for version 3.1 and 3.1.1 of the MQTT protocol.
Main homepage: http://mosquitto.org/.

![logo](https://raw.githubusercontent.com/docker-library/docs/543ed10ed132af12c3662c7a04010d3f36538094/eclipse-mosquitto/logo.png)

## How to use this image

Create a local mosquitto config file with generic credentials and relevant channel info:

```
log_dest stdout

connection_messages true
listener 1883

#enable anonymous websockets connections
listener 9001
protocol websockets

connection foundries
address mgmt.foundries.io:18830

try_private false
start_type automatic
bridge_attempt_unsubscribe false
notifications false

# Sensor notifications from the device.
topic id/+/sensor-data/+ out "" ""
```

Then run the containiner volume mounting your mosquitto config file:

```
docker run -p9001:9001 -p1883:1883 -v /path/to/mosquitto.conf:/etc/mosquitto/conf.d/mosquitto.conf hub.foundries.io/mosquitto
```
