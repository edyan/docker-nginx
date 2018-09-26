# Nginx Docker Image for PHP FPM
[![Build Status](https://travis-ci.org/edyan/docker-nginx.svg?branch=master)](https://travis-ci.org/edyan/docker-nginx)
[![Docker Pulls](https://img.shields.io/docker/pulls/edyan/nginx.svg)](https://hub.docker.com/r/edyan/nginx/)

Docker Hub: https://hub.docker.com/r/edyan/nginx

Docker container containing Nginx that connects to an FPM service. If no FPM service available, nginx will still start
but throw usual 404 errors when the actual file does not exist.

Also it has a "rewrite rule" that sends everything to index.php.

## Usage
Add the following to your docker-compose.yml, assuming that your PHP VM is named `php` (see  [edyan/php](https://github.com/edyan/docker-php)).

```yaml
nginx:
    image: edyan/nginx:1.10-debian
    volumes:
        - ./www:/var/www/html
    ports:
        - 80:80
    links:
        - php
```

If you have no `php` container, nginx will start without any upstream configuration (1.6 will throw a 500, others work).


## Versions
* `1.15-alpine` : A light version.
* `1.10-debian` : A production lookalike version with Debian 9 (also `latest`).
* `1.6-debian` : A production lookalike version with Debian 8 (throws an error if there are no upstream).


## Environment variables
Two variables have been created, to override the user and group that owns Nginx (and all its files). That's useful if you need to mount a volume and own the files. These environment variables are `NGINX_UID` and `NGINX_GID`.

Another two environment variables lets anybody override the `php` container name : `PHP_HOST` (default "php") and `PHP_PORT` (default "9000").

Finally, if you want to set your own document root, you can use `NGINX_DOCUMENT_ROOT` (default : `/var/www`)


## Tests
Tests are made with [goss](https://github.com/aelsabbahy/goss). After downloading it, run :
```bash
./test.sh 1.6-debian
./test.sh 1.10-debian
./test.sh 1.15-alpine
```
