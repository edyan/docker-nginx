#!/bin/bash
set -e

CURRENT_NGINX_ID="$(id -u www-data)"
if [[ "${CURRENT_NGINX_ID}" != "${NGINX_UID}" ]]; then
    echo "Fixing permissions for 'www-data'"
    usermod  -u ${NGINX_UID} www-data
    groupmod -g ${NGINX_GID} www-data
    chown -R www-data:www-data /var/www
    echo "Permissions fixed"
fi

if [[ ! -f /etc/nginx/conf.d/default.conf ]]; then
    echo "Using template as default site"
    envsubst '\$PHP_HOST \$PHP_PORT \$FASTCGI_READ_TIMEOUT \$FASTCGI_SEND_TIMEOUT \$NGINX_DOCUMENT_ROOT' < /etc/nginx/conf.d/default.conf.tpl > /etc/nginx/conf.d/default.conf
fi

echo "Launching command"
exec "$@"
