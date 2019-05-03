#!/bin/bash
set -e

if [[ -z "${1}" || ! -f "Dockerfile-${1}" ]]; then
    echo "You must define a valid image version to build as parameter"
    exit 1
fi

VERSION=${1}
VERSION_MINOR="$( echo ${VERSION} | cut -d"-" -f1 )"
OS="$( echo ${VERSION} | cut -d"-" -f2 )"
DIRECTORY="$( cd "$( dirname "$0" )" && pwd )"
TAG=edyan/nginx:${VERSION}
GREEN='\033[0;32m'
NC='\033[0m' # No Color

cd
echo "Building image"
${DIRECTORY}/build.sh ${VERSION} > /dev/null

# Without PHP
echo ""
echo -e "${GREEN}Test ${TAG} without PHP and default Document Root${NC}"
cd ${DIRECTORY}/../tests/test-nophp
dgoss run -e FASTCGI_READ_TIMEOUT=2s -e FASTCGI_SEND_TIMEOUT=2s -e OS=${OS} -e VERSION=${VERSION_MINOR} ${TAG}

# With PHP
echo ""
echo -e "${GREEN}Test ${TAG} with PHP${NC}"
# clean
docker stop php-test-ctn || : true > /dev/null
# create network and PHP container to run tests
docker network create nginx-test || : true > /dev/null
docker run -d --rm --network nginx-test --name php-test-ctn edyan/php
docker exec php-test-ctn bash -c "mkdir -p /var/www && echo \"<?='Hello world!'?>\" > /var/www/test.php"
# Launch nginx container
echo "Launching ${VERSION}"
cd ${DIRECTORY}/../tests/test-php
dgoss run -e OS=${OS} -e VERSION=${VERSION_MINOR} --network nginx-test -e PHP_HOST=php-test-ctn ${TAG}
# clean
docker stop php-test-ctn || : true > /dev/null
docker network rm nginx-test || : true > /dev/null

echo -e "${GREEN}Job's done${NC}"
