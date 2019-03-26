FROM alpine:latest

RUN apk add --no-cache openjdk8-jre-base

RUN mkdir -p /opt/cf-proxy
COPY Californium.properties /opt/cf-proxy
COPY ProxyMapping.properties /opt/cf-proxy
COPY Proxy.properties /opt/cf-proxy
COPY cf-proxy-2.0.0-SNAPSHOT.jar /opt/cf-proxy
COPY test.sh /test.sh

EXPOSE 5682/udp

CMD cd /opt/cf-proxy && java -jar cf-proxy-2.0.0-SNAPSHOT.jar
