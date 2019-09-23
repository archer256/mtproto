ARG DEBIAN_VERSION=buster-slim
FROM debian:${DEBIAN_VERSION}

RUN mkdir -p /usr/src/app/temp
WORKDIR /usr/src/app

RUN apt-get update -y && apt-get install -y git curl build-essential libssl-dev zlib1g-dev \
    && git clone --single-branch --depth 1 https://github.com/TelegramMessenger/MTProxy.git mtproxy-src \
    && cd mtproxy-src && make -j$(getconf _NPROCESSORS_ONLN) \
    && mv objs/bin/mtproto-proxy ../ && cd .. && rm -rf mtproxy-src \
    && apt-get remove -y git build-essential libssl-dev zlib1g-dev \
    && apt-get autoremove -y && apt-get clean

COPY run.sh /usr/src/app/

ENV EXTERNAL_IP=
ENV HTTP_PORT=433
ENV SERVICE_PORT=2398
ENV SECRET=
ENV N_WORKERS=1
ENV MAX_CONN=60000
ENV EXTRA_ARGS=

EXPOSE ${HTTP_PORT}
VOLUME /usr/src/app/temp
ENTRYPOINT ["./run.sh"]
