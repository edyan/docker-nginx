FROM        nginx:1.15-alpine
MAINTAINER  Emmanuel Dyan <emmanueldyan@gmail.com>

# Installation
RUN         apk update && apk add --no-cache gettext && \
            mv /usr/local/bin/envsubst /bin/ && \
            apk del gettext && \
            rm -rf /var/cache/apk/*

# Configuration
COPY        conf/default /etc/nginx/conf.d/default.conf

# create root tree for default vhost
RUN         mkdir /var/www
RUN         chown nginx:nginx /var/www

ENV         NGINX_UID 100
ENV         NGINX_GID 101
ENV         PHP_HOST  php
ENV         PHP_PORT  9000

EXPOSE      80

COPY        run.sh     /run.sh
RUN         chmod u+x  /run.sh

CMD         ["/run.sh"]
