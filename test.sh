#!/bin/bash

set -e

if [ -z "$1" -o ! -d "$1" ]; then
    echo "You must define a valid Nginx version to build as parameter"
    exit 1
fi

DIRECTORY=$(cd `dirname $0` && pwd)
VERSION=$1
GREEN='\033[0;32m'
NC='\033[0m' # No Color
TAG=edyan/nginx:${VERSION}

echo "Building ${VERSION}"
./build.sh ${VERSION} > /dev/null

echo ""
echo -e "${GREEN}Test ${TAG} without PHP and default Document Root${NC}"
cd ${DIRECTORY}/${1}/tests/test-nophp
dgoss run ${TAG}


echo ""
echo -e "${GREEN}Test ${TAG} with PHP${NC}"
# clean
docker stop php-test-ctn || : true > /dev/null
# create network and PHP container to run tests
docker network create nginx-test || : true > /dev/null
docker run -d --rm --network nginx-test --name php-test-ctn edyan/php
docker exec php-test-ctn bash -c "mkdir -p /var/www && echo \"<?='Hello world!'?>\" > /var/www/test.php"
# Go with nginx container
echo "Launching ${VERSION}"
cd ${DIRECTORY}/${1}/tests/test-php
dgoss run --network nginx-test -e PHP_HOST=php-test-ctn ${TAG}
# clean
docker stop php-test-ctn || : true > /dev/null
docker network rm nginx-test || : true > /dev/null

echo -e "${GREEN}Job's done${NC}"
