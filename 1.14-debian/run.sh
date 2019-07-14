#!/bin/sh
CURRENT_NGINX_ID=$(id -u www-data)
if [ "$CURRENT_NGINX_ID" != "$NGINX_UID" ]; then
    echo "Fixing permissions for Nginx"
    usermod  -u $NGINX_UID www-data
    groupmod -g $NGINX_GID www-data
    chown -R www-data:www-data /var/www /var/lib/nginx /var/log/nginx
fi

if [ ! -f /etc/nginx/sites-available/default ]; then
    echo "Using template as default site"
    envsubst '\$PHP_HOST \$PHP_PORT \$NGINX_DOCUMENT_ROOT' < /etc/nginx/sites-available/default.tpl > /etc/nginx/sites-available/default
fi

echo "Starting nginx"
exec nginx -g 'daemon off;'
