#!/bin/sh
CURRENT_NGINX_ID=$(id -u www-data)
if [ "$CURRENT_NGINX_ID" != "$NGINX_UID" ]; then
    echo "Fixing permissions for Nginx"
    usermod  -u $NGINX_UID www-data
    groupmod -g $NGINX_GID www-data
    chown -R www-data:www-data /var/www /var/lib/nginx /var/log/nginx
fi

envsubst '\$PHP_HOST \$PHP_PORT' < /etc/nginx/sites-available/default > /etc/nginx/sites-available/default

exec nginx -g 'daemon off;'
