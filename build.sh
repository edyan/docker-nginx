#!/bin/bash

set -e

if [ -z "$1" -o ! -d "$1" ]; then
    echo "You must define a valid Nginx version to build as parameter"
    exit 1
fi

VERSION=$1
GREEN='\033[0;32m'
NC='\033[0m' # No Color
TAG=edyan/nginx:${VERSION}

cd $1

echo "Building ${TAG}"
docker build -t ${TAG} .
if [[ "$VERSION" == "1.14-debian" ]]; then
  echo ""
  echo "${TAG} will also be tagged 'latest'"
  docker tag ${TAG} edyan/nginx:latest
fi

echo ""
echo ""
if [ $? -eq 0 ]; then
    echo -e "${GREEN}Build Done${NC}."
    echo ""
    echo "Run (with PHP) :"
    echo "  docker network create nginx-test"
    echo "  docker container run -d --rm --network nginx-test --name php edyan/php:latest"
    echo "  docker container run -d --rm --network nginx-test --name nginx${VERSION}-test-ctn -p 8080:80 ${TAG}"
    echo "  docker container exec -ti nginx${VERSION}-test-ctn /bin/bash"
    echo "Once Done : "
    echo "  docker container stop nginx${VERSION}-test-ctn"
    echo "  docker container stop php"
    echo "  docker network rm nginx-test"
    echo ""
    echo "Or if you want to directly enter the container, then remove it : "
    echo "  docker run -ti --rm edyan_nginx${VERSION}_test /bin/bash"
    echo "To push that version (and other of the same repo):"
    echo "  docker push edyan/nginx"
fi
