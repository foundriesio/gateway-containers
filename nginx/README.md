A cross-platform container for Nginx containing an [experimental DTLS patch](https://source.foundries.io/gateway-containers.git/tree/nginx/nginx-1.13.9-dtls-experimental.diff).
Usage details can be found with the [official Docker image](https://hub.docker.com/_/nginx/).

## How to use this image

Its recommend to use the official Docker image for normal HTTP(S) services.
This image is built to serve as an LWM2M Proxy.

Create a local nginx config file containing the desired options:

```
$ cat nginx-lwm2m.conf
user  nginx;
worker_processes  1;

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
        proxy_pass  mgmt.foundries.io:5683;
    }

    server {
        listen  [::]:5684 udp;
        listen  0.0.0.0:5684 udp;
        proxy_pass  mgmt.foundries.io:5684;
    }
}
```

Then start the container by overwriting nginx.conf:

```
docker run -p 5683:5683/udp -p 5684:5684/udp -v /path/to/nginx-lwm2m.conf:/etc/nginx/nginx.conf hub.foundries.io/nginx
```

### Debug mode

To enable debug mode in NGINX, a different binary needs to be used (nginx-debug). Just overwrite the default docker CMD and start with nginx-debug instead:

```
docker run -p 5683:5683/udp -p 5684:5684/udp -v /path/to/nginx-lwm2m.conf:/etc/nginx/nginx.conf hub.foundries.io/nginx nginx-debug -g 'daemon off;'
```
