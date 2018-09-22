#!/bin/sh
CURRENT_NGINX_ID=$(id -u nginx)
if [ "$CURRENT_NGINX_ID" != "$NGINX_UID" ]; then
    echo "Fixing permissions for 'nginx'"
    sed -i "s/:100:101:Linux User/:$NGINX_UID:$NGINX_GID:Nginx System User/g" /etc/passwd
    sed -i "s/:101:nginx/:$NGINX_GID:nginx/g" /etc/group
    chown -R nginx:nginx /var/www /var/log/nginx
fi

envsubst '\$PHP_HOST \$PHP_PORT' < /etc/nginx/conf.d/default.conf > /etc/nginx/conf.d/default.conf

exec nginx -g 'daemon off;'
