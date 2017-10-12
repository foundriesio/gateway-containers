# Open Source Foundries IoT Gateway Containers

## Quick Start

On a fresh image (capable of running docker), run the following commands to bootstrap your OSF IoT Gateway environment:

### Bluetooth LE 6LoWPAN Joiner

Create the bluetooth 6lowpand configuration file:

```
HCI_INTERFACE=hci0
SCAN_WIN=3
SCAN_INT=6
MAX_DEVICES=8

# Change to USE_WL=1 to use whitelisted MAC addresses
USE_WL=0

# If you set USE_WL=1, then add a WL entry for each of your devices'
# MAC addresses, like so:
# WL=DE:AD:BE:EF:DE:AD
```

Start the container:

```
docker run --restart=always -d -t --privileged --net=host --read-only --tmpfs=/var/run --tmpfs=/var/lock --tmpfs=/var/log -v /home/linaro/bluetooth_6lowpand.conf:/etc/bluetooth/bluetooth_6lowpand.conf --name bt-joiner linarotechnologies/bt-joiner:latest
```

### Mosquitto MQTT Broker

Brokering MQTT data from an IoT device to an apporpriate data system can be done using a pre-built mosquitto broker.  Though you can run any number of brokers, you would want to change the expost port before trying to run multiple brokers.  It's typical that you would run one of these containers on your gateway.

#### Option 1: IBM Bluemix Mosquitto

Create the authentication keys file:

```
$ cat ~/ibm-bluemix-mosquitto.env
BLUEMIX_AUTHKEY=a-org-authkey
BLUEMIX_AUTHTOKEN=auth-token
BLUEMIX_ORG=bluemix-org
GW_DEVICE_TYPE=hikey
```

Start the container:

```
docker run --restart=always -d -t --net=host --env-file=/home/linaro/ibm-bluemix-mosquitto.env --name ibm-bluemix-mosquitto linarotechnologies/ibm-bluemix-mosquitto:latest
```

#### Option 2: Generic Mosquitto broker

Create a local mosquitto configuration file:

```
$ cat ~/mosquitto.conf
# General settings
log_dest stdout

# Bridge configuration
connection #connection-name
address #url:#port
remote_username #username
remote_password #password
try_private false
start_type automatic
bridge_attempt_unsubscribe false
notifications false
connection_messages true

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

Start the container:

```
docker run --restart=always -d -t --net=host --read-only -v /home/linaro/mosquitto.conf:/etc/mosquitto/conf.d/mosquitto.conf --name mosquitto linarotechnologies/mosquitto:latest
```
