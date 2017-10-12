FROM linarotechnologies/alpine:edge

RUN apk add --no-cache wget openjdk8-jre-base ca-certificates

RUN mkdir -p /opt/cf-proxy
COPY Californium.properties /opt/cf-proxy
COPY ProxyMapping.properties /opt/cf-proxy
COPY Proxy.properties /opt/cf-proxy
RUN cd /opt/cf-proxy && \
    wget https://api.foundries.io/projects/development/cf-proxy-coap-http/builds/2/runs/cf-proxy-coap-http/cf-proxy-1.1.0-SNAPSHOT.jar

EXPOSE 5682

CMD cd /opt/cf-proxy && java -jar cf-proxy-1.1.0-SNAPSHOT.jar
