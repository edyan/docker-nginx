# Nginx Docker Image for PHP FPM
[![Build Status](https://travis-ci.com/edyan/docker-nginx.svg?branch=master)](https://travis-ci.com/edyan/docker-nginx)
[![Docker Pulls](https://img.shields.io/docker/pulls/edyan/nginx.svg)](https://hub.docker.com/r/edyan/nginx/)

Docker Hub: https://hub.docker.com/r/edyan/nginx

Docker container containing Nginx that connects to an FPM service and redirects
all requests to /index.php. 
If the FPM service is not available, nginx will still start but throws 
500 errors when the actual file does not exist.

**WARNING** : If you have an index.php, everything will be redirected to it. If your index.php
is not able to manage routes, you'll have a strange behavior. 

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
```

If you have no `php` container, nginx will start without any upstream configuration (1.6 will throw a 500, others work).


## Versions
* `1.17-alpine` : A light version.
* `1.14-debian` : A production lookalike version with Debian 10 (also `latest`).
* `1.10-debian` : A production lookalike version with Debian 9
* `1.6-debian` : A production lookalike version with Debian 8 (throws an error if there are no upstream).


## Environment variables
Two variables have been created, to override the user and group that owns Nginx 
(and all its files). That's useful if you need to mount a volume and own the files. 
These environment variables are `NGINX_UID` and `NGINX_GID`.

Another two environment variables lets anybody override the `php` container name : 
`PHP_HOST` (default "php") and `PHP_PORT` (default "9000").


Finally: 
* To set your own document root, you can use `NGINX_DOCUMENT_ROOT` (default : `/var/www`) 
* To fine tune the fastcgi timeout you can change 
`FASTCGI_READ_TIMEOUT` (default 20s) and `FASTCGI_SEND_TIMEOUT` (default 20s).


## Tests
Tests are made with [goss](https://github.com/aelsabbahy/goss). After downloading it, run :
```bash
scripts/test.sh 1.6-debian
scripts/test.sh 1.10-debian
scripts/test.sh 1.14-debian
scripts/test.sh 1.17-alpine
```
