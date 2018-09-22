FROM        nginx:1.15-alpine
MAINTAINER  Emmanuel Dyan <emmanueldyan@gmail.com>

# Installation
RUN         apk update && apk add --no-cache gettext shadow && \
            mv /usr/local/bin/envsubst /bin/ && \
            apk del gettext && \
            rm -rf /var/cache/apk/*

# Prepare env and change user
RUN         mkdir /var/www
RUN         groupmod -g 101 -n www-data nginx
RUN         usermod  -g 101 -u 100 -l www-data -d /var/www nginx
RUN         chown www-data:www-data /var/www


# Configuration
RUN         sed -i 's/^user .*nginx;/user  www-data;/g' /etc/nginx/nginx.conf
COPY        conf/default /etc/nginx/conf.d/default.conf


ENV         NGINX_UID 100
ENV         NGINX_GID 101
ENV         PHP_HOST  php
ENV         PHP_PORT  9000

EXPOSE      80

COPY        run.sh     /run.sh
RUN         chmod u+x  /run.sh

CMD         ["/run.sh"]
