# Open Source Foundries IoT Gateway Containers

## Quick Start

On a fresh image (capable of running docker), run the following commands to bootstrap your OSF IoT Gateway environment:

In order to access the registry, you will need to login using the docker
command line using your subscriber id and a personal access token

Log into the Registry:

```
docker login registry.foundries.io
Username: <subscriber id>
Password: <personal access token with 'api' scope for Git over HTTP>
```

### bt-joiner, a Bluetooth LE / 6LoWPAN joining script

In order to connect Bluetooth low energy devices we will use the bt-joiner
container.  The container can be configured using the Bluetooth/6LoWPAN configuration file; ~/bluetooth_6lowpand.conf:

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
docker run --restart=always -d -t --privileged --net=host --read-only \
  --tmpfs=/run --tmpfs=/var/lock --tmpfs=/var/log \
  -v /home/osf/bluetooth_6lowpand.conf:/etc/bluetooth/bluetooth_6lowpand.conf \
  --name bt-joiner \
  registry.foundries.io/development/microplatforms/linux/gateway-containers/bt-joiner:latest
```

### Mosquitto MQTT Broker

Brokering MQTT data from an IoT device to an appropriate data system can be
done using a pre-built mosquitto broker.  Mosquitto is a comprehensive
MQTT broker that can be used to securely bridge to other MQTT servers,  in
this example we provide a simple local-only only configuration.

Create a mosquitto configuration file, ~/mosquitto.conf:

```
# Configuration for a local-only mqtt broker
log_dest stdout

connection_messages true
listener 1883

#enable a anonymous websockets connection
listener 9001
protocol websockets
```

Start the container:

```
docker run --restart=always -d -t --net=host --read-only \
  -v /home/osf/mosquitto.conf:/etc/mosquitto/conf.d/mosquitto.conf \
  --name mosquitto \
  registry.foundries.io/development/microplatforms/linux/gateway-containers/mosquitto:latest
```

### HTTP Proxy (nginx-http-proxy)

In order to proxy traffic from the IPv6 IoT devices connected via 6LoWPAN
over BLE, we use a simple NGINX proxy configuration.

Create an nginx configuration file; nginx-http-proxy.conf:
```
user  nginx;
worker_processes  auto;

error_log  /var/log/nginx/error.log debug;
pid        /var/run/nginx.pid;

events {
    worker_connections  1024;
}

http {
    server {
        listen  [::]:8080;
        listen  0.0.0.0:8080;

        location  /DEFAULT {
            proxy_pass  http://mgmt.foundries.io:8080;
        }
    }
}
```

Start the Container:

```
export GW_HOSTNAME=192.168.0.43
docker run --restart=always -d -t --net=host \
    --read-only --tmpfs=/var/run --tmpfs=/var/cache/nginx \
    --add-host=mgmt.foundries.io:$GW_HOSTNAME \
    -v /home/osf/nginx-http-proxy.conf:/etc/nginx/nginx.conf \
    --name nginx-http-proxy registry.foundries.io/development/microplatforms/linux/gateway-containers/nginx:latest \
    nginx-debug -g 'daemon off;'
```

### HTTP/COAP proxy

To route COAP messages (udp) across HTTP we use a HTTP/COAP proxy using
a second nginx instance.

Create an nginx configuration file; nginx-lwm2m.conf:
```
user  nginx;
worker_processes  auto;

error_log  /var/log/nginx/error.log debug;
pid        /var/run/nginx.pid;

events {
    worker_connections  1024;
}

stream {
    log_format  basic  '$remote_addr [$time_local] '
                       '$protocol $status $bytes_sent $bytes_received '
                       '$session_time';

    access_log  /var/log/nginx/access.log basic buffer=32k;

    server {
        listen  [::]:5683 udp;
        listen  0.0.0.0:5683 udp;
        proxy_connect_timeout 10s;
        proxy_timeout 5m;
        proxy_pass  mgmt.foundries.io:5683;
    }

    server {
        listen  [::]:5684 udp;
        listen  0.0.0.0:5684 udp;
        proxy_connect_timeout 10s;
        proxy_timeout 5m;
        proxy_pass  mgmt.foundries.io:5684;
    }

    server {
        listen  [::]:5685 udp;
        listen  0.0.0.0:5685 udp;
        proxy_connect_timeout 10s;
        proxy_timeout 5m;
        proxy_pass  mgmt.foundries.io:5685;
    }
}
```

start the container:

```
export GW_HOSTNAME=192.168.0.43
docker run --restart=always -d -t --net=host \
    --read-only --tmpfs=/var/run  --add-host=mgmt.foundries.io:$GW_HOSTNAME \
    -v /home/osf/nginx-lwm2m.conf:/etc/nginx/nginx.conf \
    --name nginx-coap-proxy registry.foundries.io/development/microplatforms/linux/gateway-containers/nginx:latest \
    nginx-debug -g 'daemon off;'
```
