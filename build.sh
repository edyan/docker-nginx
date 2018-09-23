#!/bin/bash

set -e

if [ -z "$1" -o ! -d "$1" ]; then
    echo "You must define a valid Nginx version to build as parameter"
    exit 1
fi

VERSION=$1
GREEN='\033[0;32m'
NC='\033[0m' # No Color

cd $1
docker build -t "edyan_nginx${VERSION}_test" .
echo ""
echo ""
if [ $? -eq 0 ]; then
    echo -e "${GREEN}Build Done${NC}."
    echo ""
    echo "Run (with PHP) :"
    echo "  docker network create nginx-test"
    echo "  docker run -d --network nginx-test --rm --name php-test-ctn edyan/php:latest"
    echo "  docker run -d --network nginx-test --rm -e PHP_HOST=php-test-ctn --name nginx${VERSION}-test-ctn edyan_nginx${VERSION}_test"
    echo "  docker exec -i -t nginx${VERSION}-test-ctn /bin/bash"
    echo "Once Done : "
    echo "  docker stop nginx${VERSION}-test-ctn"
    echo "  docker stop php-test-ctn"
    echo "  docker network rm nginx-test"
    echo ""
    echo "Or if you want to directly enter the container, then remove it : "
    echo "  docker run -ti --rm edyan_nginx${VERSION}_test /bin/bash"
fi
