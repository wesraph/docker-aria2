FROM alpine:3.8

RUN apk add --no-cache shadow curl aria2 && \
    useradd -s /bin/sh -m aria2

ADD https://caddyserver.com/download/linux/amd64?license=personal&telemetry=off /tmp/caddy.tar.gz
ADD https://github.com/mayswind/AriaNg/releases/download/1.0.0/AriaNg-1.0.0-AllInOne.zip /tmp/ariang.zip

RUN tar -xvf /tmp/caddy.tar.gz caddy -C /usr/local/bin && \
    mkdir -p /home/aria2/web/ && unzip /tmp/ariang.zip -d /home/aria2/ && \
    rm -rf /tmp/* /home/aria2/LICENSE

COPY aria2.conf /home/aria2/aria2.conf
COPY Caddyfile /home/aria2/Caddyfile
COPY on-complete-hook.sh /home/aria2/on-complete-hook.sh
COPY run.sh /usr/bin/aria2.sh

EXPOSE 6800
CMD ["/usr/bin/aria2.sh"]
