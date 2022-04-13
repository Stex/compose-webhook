FROM        golang:alpine3.11 AS build
WORKDIR     /go/src/github.com/adnanh/webhook
ENV         WEBHOOK_VERSION 2.8.0
RUN         apk add --update -t build-deps curl libc-dev gcc libgcc
RUN         curl -L --silent -o webhook.tar.gz https://github.com/adnanh/webhook/archive/${WEBHOOK_VERSION}.tar.gz && \
            tar -xzf webhook.tar.gz --strip 1 &&  \
            go get -d && \
            go build -o /usr/local/bin/webhook && \
            apk del --purge build-deps && \
            rm -rf /var/cache/apk/* && \
            rm -rf /go

FROM linuxserver/docker-compose:v2
RUN         apk add --no-cache curl bash
COPY        --from=build /usr/local/bin/webhook /usr/local/bin/webhook
COPY        ./docker-entrypoint.sh /docker-entrypoint.sh
WORKDIR     /etc/webhook
EXPOSE      9000
ENTRYPOINT  ["/docker-entrypoint.sh"]
CMD         [ "/usr/local/bin/webhook", "-verbose", "-hotreload", "-hooks=/etc/webhook/hooks.yml" ]
