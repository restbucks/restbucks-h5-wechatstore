#!/usr/bin/env bash -ex

BFF_HOST=$1
BFF_PORT=$2

function checkBffHost {
    if [ "$1x" = "x" ]
    then
        echo 'Please specify BFF_HOST'
        return -1;
    fi
}

checkBffHost ${BFF_HOST}

if [ "${BFF_PORT}x" = "x" ]
then
    BFF_PORT="80"
fi

docker run \
    --name restbucks-nginx-wechatstore \
    -it --rm \
    -p 80:80 \
    -e BFF_HOST=${BFF_HOST} \
    -e BFF_PORT=${BFF_PORT} \
    -v $(PWD)/app:/usr/share/nginx/html:ro \
    -v $(PWD)/nginx/conf.d:/etc/nginx/conf.d:rw \
    nginx:1.11.4-alpine \
    /bin/sh -c "envsubst '\$BFF_HOST \$BFF_PORT' < /etc/nginx/conf.d/wechat-store.conf.template > /etc/nginx/conf.d/default.conf && nginx -g 'daemon off;'"