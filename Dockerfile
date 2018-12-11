FROM alpine:latest

RUN apk update && apk add --no-cache supervisor dnsmasq bind-tools openrc

RUN echo 'conf-dir=/etc/dnsmasq.d/,*.conf' > /etc/dnsmasq.conf && echo "user=root" >> /etc/dnsmasq.conf

COPY supervisord.conf /etc/supervisord.conf

COPY change-ip.sh /usr/local/bin/change-ip.sh
RUN chmod u+x /usr/local/bin/change-ip.sh

ENTRYPOINT ["supervisord","--configuration","/etc/supervisord.conf"]