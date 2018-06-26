# Open Source Foundries IoT Gateway Containers

## docker-compose Quick Start

To quickly configure your a device running the Linux microPlatform as an IoT gateway that communicates with our demonstration servers located at https://mgmt.foundries.io, you can use the included docker-compose file.

Usage:
To use the public docker images at Docker hub:

```
# First, ssh to the target system and get the source
git clone https://github.com/opensourcefoundries/gateway-containers
cd gateway-containers

# Run docker-compose, bring up all containers as daemons
docker-compose up -d
```

OSF Subscribers may wish to pull the latest containers
```
# First, ssh to the target system and get the source
git clone git clone https://source.foundries.io/gateway-containers
cd gateway-containers

# Log into hub.foundries.io
docker login hub.foundries.io
username: notused
passsword: subscriber APP Token from https://foundries.io/settings/tokens/

# Run docker-compose, bring up all containers as daemons
REGISTRY=hub.foundries.io docker-compose up -d
```

**Note:** The docker-compose.yml file also allows the use of a `TAG` variable
to reference that version of the container to be used by docker-compose.
The `TAG` coincides with the microPlatform update number, such as 0.22 or 0.23.

To view all of the available tags for the nginx container browse to: https://hub.docker.com/r/opensourcefoundries/nginx/tags/.

```
# Use the TAG variable to load an older version of the containers
TAG=0.21 docker-compose up
```

# Brief container descriptions

### bt-joiner, a Bluetooth LE / 6LoWPAN joining script

In order to connect Bluetooth low energy devices we will use the bt-joiner
container.

### Mosquitto MQTT Broker

Brokering MQTT data from an IoT device to an appropriate data system can be
done using a pre-built mosquitto broker.  Mosquitto is a comprehensive
MQTT broker that can be used to securely bridge to other MQTT servers.

### HTTP Proxy (nginx-http-proxy)

In order to proxy traffic from the IPv6 IoT devices connected via 6LoWPAN
over BLE, we use a simple NGINX proxy configuration.

### HTTP/COAP proxy

To route COAP messages (udp) across HTTP we use a HTTP/COAP proxy using
a second nginx instance.

### Californium proxy

To proxy the CoAP traffic (udp) we use the Californium proxy
