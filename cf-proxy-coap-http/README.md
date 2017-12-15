# Californium CoAP-HTTP Proxy

## Build the container

```
docker build -t cf-proxy-coap-http --force-rm -f Dockerfile .
```

## Run the container

```
docker run --restart=always -d -t --net=host --read-only --name cf-proxy-coap-http cf-proxy-coap-http
```

## Run the pre-built container

```
docker run --restart=always -d -t --net=host --read-only --name cf-proxy-coap-http opensourcefoundries/cf-proxy-coap-http:latest
```
