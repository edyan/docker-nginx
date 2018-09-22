#!/bin/sh
CURRENT_NGINX_ID=$(id -u www-data)
if [ "$CURRENT_NGINX_ID" != "$NGINX_UID" ]; then
    echo "Fixing permissions for 'www-data'"
    usermod  -u $NGINX_UID www-data
    groupmod -g $NGINX_GID www-data
    chown -R www-data:www-data /var/www /var/log/www-data
fi

envsubst '\$PHP_HOST \$PHP_PORT' < /etc/nginx/conf.d/default.conf > /etc/nginx/conf.d/default.conf

exec nginx -g 'daemon off;'
