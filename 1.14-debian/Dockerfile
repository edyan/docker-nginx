FROM        debian:buster-slim
MAINTAINER  Emmanuel Dyan <emmanueldyan@gmail.com>

ARG         DEBIAN_FRONTEND=noninteractive

# Set a default conf for apt install
RUN         echo 'apt::install-recommends "false";' > /etc/apt/apt.conf.d/no-install-recommends && \
            # Upgrade the system and Install PHP
            apt update && \
            apt upgrade -y && \
            # Packages
            apt install -y nginx gettext-base && \
            # Clean
            rm -f /etc/nginx/sites-available/default && \
            apt autoremove -y && \
            apt autoclean && \
            apt clean && \
            rm -rf /var/lib/apt/lists/* /usr/share/man/* /usr/share/doc/* /var/cache/* /var/log/*

# Configuration
COPY        conf/default /etc/nginx/sites-available/default.tpl

RUN         mv /var/www/html/* /var/www/ && rm -rf /var/www/html && \
            mv /var/www/index.nginx-debian.html /var/www/index.html && \
            mkdir /var/log/nginx && \
            chmod 755 /var/log/nginx

ENV         NGINX_UID 33
ENV         NGINX_GID 33
ENV         NGINX_DOCUMENT_ROOT /var/www
ENV         PHP_HOST  php
ENV         PHP_PORT  9000

EXPOSE      80

COPY        run.sh     /run.sh
RUN         chmod u+x  /run.sh

CMD         ["/run.sh"]
