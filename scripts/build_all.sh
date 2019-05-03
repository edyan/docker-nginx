#!/bin/bash
set -e

DIR="$( cd "$( dirname "$0" )" && pwd )"

cd ${DIR}/../
for i in $(ls -d Dockerfile-*|sed -e "s/Dockerfile-/$1/g"); do
    NGINX_VERSION=${i%%/}
    echo "Building and testing ${NGINX_VERSION}"
    scripts/test.sh ${NGINX_VERSION}|grep "Failed: "
    echo ""
    echo ""
done
