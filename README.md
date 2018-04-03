# Nginx Docker Image for PHP FPM
Docker Hub: https://hub.docker.com/r/edyan/nginx

Docker container containing Nginx that connects to an FPM service.

## Usage
Add the following to your docker-compose.yml, assuming that your PHP VM is named `php` (see  [edyan/php](https://github.com/edyan/docker-php)).

```yaml
nginx:
    image: edyan/nginx
    volumes:
        - ./www:/var/www/html
    ports:
        - 80:80
    links:
        - php
```


## Environment variables
Two variables have been created, to override the user and group that owns Nginx (and all its files).
That's useful if you need to mount a volume and own the files.

These environment variables are `NGINX_UID` and `NGINX_GID`.
