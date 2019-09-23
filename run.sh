#!/bin/sh

set -x

curl -s https://core.telegram.org/getProxySecret -o temp/proxy-secret
curl -s https://core.telegram.org/getProxyConfig -o temp/proxy-multi.conf
exec ./mtproto-proxy -u root --port ${SERVICE_PORT} --http-port ${HTTP_PORT} --http-stats --nat-info "$(hostname --ip-address):${EXTERNAL_IP}" -c ${MAX_CONN} --aes-pwd temp/proxy-secret -M ${N_WORKERS} -S ${SECRET} ${EXTRA_ARGS} temp/proxy-multi.conf
