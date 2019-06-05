# Foundries IoT Gateway Containers

## Docker Compose Quick Start

To quickly configure your a device running the Linux microPlatform as an IoT
gateway that communicates with our demonstration servers located at
https://mgmt.foundries.io, you can use the included docker-compose files.

Usage:
```
# First, ssh to the target system and get the source
git clone https://github.com/foundriesio/gateway-containers
cd gateway-containers

# Run docker-compose, bring up all containers as daemons
docker-compose -f docker-compose.lwm2m.yml -f docker-compose.hawkbit.yml up -d
```

**Note:** Both `docker-compose.yml` files also allow the use of a `TAG` variable
to reference that version of the container to be used by docker-compose.
The `TAG` coincides with the microPlatform update number, such as 43 or 44.

To view all of the available tags for the nginx container browse to: https://hub.foundries.io/nginx.html

```
# Use the TAG variable to load an older version of the containers
TAG=44 docker-compose -f docker-compose.lwm2m.yml -f docker-compose.hawkbit.yml up -d
```

## LWM2M Specific Containers

To configure your Linux microPlatform device as a LWM2M IoT gateway only,
use the compose file `docker-compose.lwm2m.yml` when running docker-compose:

```
docker-compose -f docker-compose.lwm2m.yml up -d
```

### Using Local Leshan Server

To proxy the LWM2M based connections to another server (instead of `mgmt.foundries.io`),
use the compose override file `docker-compose.lwm2m.local.yml`:

```
MGMT_SERVER="192.168.1.1" docker-compose -f docker-compose.lwm2m.yml -f docker-compose.lwm2m.local.yml up -d
```

## hawkBit/MQTT Specific Containers

To configure your Linux microPlatform device as a hawkBit/MQTT IoT gateway only,
use the compose file `docker-compose.hawkbit.yml` when running docker-compose:

```
docker-compose -f docker-compose.hawkbit.yml up -d
```

### Using Local hawkBit Server

To proxy the HTTP/hawkBit/MQTT based connections to another server (instead of `mgmt.foundries.io`),
use the compose override file `docker-compose.hawkbit.local.yml`:

```
MGMT_SERVER="192.168.1.1" docker-compose -f docker-compose.hawkbit.yml -f docker-compose.hawkbit.local.yml up -d
```

## Brief container descriptions

### nat64-jool, stateful NAT64 kernel module loader / interface setup script

This container will unload and reload existing Jool kernel module passing in
the specified NAT64 subnet.  It will also setup forwarding across all interfaces
for IPv4 and IPv6.  This container works for routing IPv6 traffic to private
internal networks.

### nat64-tayga, stateless NAT64 userspace-based router

Tayga is a stateless userspace-based NAT64 implementation.  The container
configures the specified IPv6 and IPv4 subnets for routing as well as
enables forwarding for IPv4 and IPv6.  This container does *NOT* work for
routing IPv6 traffic to private internal networks.

### radvd64, a router advertisement daemon for dynamic IPv6 interfaces

This container starts a specialized deployment of radvd for use with BLE
6lowpan and 802.15.4 networks.

### iface-monitor, a network interface script to add an IP on interface up

Network interfaces often need a new IP address to be added after they come up
in order to be used for DNS64 or other purposes.  This container acts as an
interface "up" trigger and will automatically add the configured IP address.

### ot-wpantund, OpenThread NCP management daemon

"wpantund" is a user-space network interface driver/daemon that provides a
native IPv6 network interface to a low-power wireless Network Co-Processor
(or NCP). wpantund is designed to marshall all access to the NCP, ensuring that
it always remains in a consistent and well-defined state.

### bt-joiner, a Bluetooth LE / 6LoWPAN joining script

In order to connect Bluetooth low energy devices we will use the bt-joiner
container.

### Mosquitto MQTT Broker

Brokering MQTT data from an IoT device to an appropriate data system can be
done using a pre-built mosquitto broker.  Mosquitto is a comprehensive
MQTT broker that can be used to securely bridge to other MQTT servers.

### HTTP/COAP proxy

To route COAP messages (udp) across HTTP we use a HTTP/COAP proxy using
a second nginx instance.

### Californium proxy

To proxy the CoAP traffic (udp) we use the Californium proxy
