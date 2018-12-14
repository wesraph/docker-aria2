FROM alpine:3.8

RUN apk add --no-cache shadow aria2 && \
    useradd -s /bin/sh -m aria2

COPY aria2.conf /home/aria2/aria2.conf
COPY on-complete-hook.sh /home/aria2/on-complete-hook.sh
COPY run.sh /usr/bin/aria2.sh

EXPOSE 6800
CMD ["/usr/bin/aria2.sh"]
