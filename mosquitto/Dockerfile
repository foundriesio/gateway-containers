FROM alpine:latest

RUN apk add --no-cache ca-certificates mosquitto

EXPOSE 1883 8883

COPY test.sh test.sh
COPY start.sh start.sh
ENTRYPOINT ["/start.sh"]

CMD /usr/sbin/mosquitto -c /etc/mosquitto/conf.d/mosquitto.conf
