#!/bin/sh
usermod  -u $NGINX_UID www-data
groupmod -g $NGINX_GID www-data
chown -R www-data:www-data /var/lib/nginx /var/log/nginx

exec nginx -g 'daemon off;'
