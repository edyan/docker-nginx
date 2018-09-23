#!/bin/bash
NAME="edyan_nginx_1.15-alpine_test"
docker build -t $NAME .
dgoss run $NAME
