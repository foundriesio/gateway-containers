# NGINX

## Build the container

```
docker build -t nginx --force-rm -f Dockerfile .
```

## Run the container

```
docker run --restart=always -d -t --net=host --read-only --tmpfs=/var/run --name nginx nginx
```

### LWM2M Proxy

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
docker run --restart=always -d -t --net=host --read-only --tmpfs=/var/run --add-host=mgmt.foundries.io:<lwm2m server ip address> -v /path/to/nginx-lwm2m.conf:/etc/nginx/nginx.conf --name nginx nginx
```

### Debug mode

To enable debug mode in NGINX, a different binary needs to be used (nginx-debug). Just overwrite the default docker CMD and start with nginx-debug instead:

```
docker run --restart=always -d -t --net=host -v /path/to/nginx-lwm2m.conf:/etc/nginx/nginx.conf --name nginx nginx nginx-debug -g 'daemon off;'
```

## Run the pre-built container

```
docker run --restart=always -d -t --net=host --read-only --tmpfs=/var/run --add-host=mgmt.foundries.io:<lwm2m server ip address> -v /path/to/nginx-lwm2m.conf:/etc/nginx/nginx.conf --name nginx linarotechnologies/nginx:latest
```
