#!/bin/bash

set -e

DIR="$( cd "$( dirname "$0" )" && pwd )"
DOCKERFILE="${DIR}/../Dockerfile-${1}"
if [[ -z "${1}" || ! -f ${DOCKERFILE} ]]; then
    echo "You must define a valid Nginx version to build as parameter"
    exit 1
fi

VERSION=$1
GREEN='\033[0;32m'
NC='\033[0m' # No Color
TAG=edyan/nginx:${VERSION}

cd ${DIR}/../

# Check if git repo is clean
GIT_AVAILABLE=$(which git)
GIT_FILES_TO_COMMIT=$(git status --porcelain)
if [[ "${GIT_AVAILABLE}" != "" && "${GIT_FILES_TO_COMMIT}" != "" ]]; then
    echo "You must make sure Git repo has been commited" >&2
    exit 1
fi

# Build Image
echo "Building ${TAG}"
docker build --tag ${TAG} \
             --cache-from ${TAG} \
             --build-arg BUILD_DATE="$(date -u +'%Y-%m-%dT%H:%M:%SZ')" \
             --build-arg VCS_REF="$(git rev-parse --short HEAD)" \
             --build-arg DOCKER_TAG="${TAG}" \
             -f ${DOCKERFILE} \
             .

# Tag latest
if [[ "${VERSION}" == "1.14-debian" ]]; then
  echo ""
  echo "${TAG} will also be tagged 'latest'"
  docker tag ${TAG} edyan/nginx:latest
fi

# Nice Message
echo ""
echo ""
if [[ $? -eq 0 ]]; then
    echo -e "${GREEN}Build Done${NC}."
    echo ""
    echo "Run (with PHP) :"
    echo "  docker network create nginx-test"
    echo "  docker container run -d --rm --network nginx-test --name nginx${VERSION}-test-ctn -p 8080:80 ${TAG}"
    echo "  docker container run -d --rm --network nginx-test --volumes-from nginx${VERSION}-test-ctn --name php edyan/php:latest"
    echo "  docker container exec -ti nginx${VERSION}-test-ctn /bin/bash"
    echo "Once Done : "
    echo "  docker container stop nginx${VERSION}-test-ctn"
    echo "  docker container stop php"
    echo "  docker network rm nginx-test"
    echo ""
    echo "Or if you want to directly enter the container, then remove it : "
    echo "  docker run -ti --rm ${TAG} /bin/bash"
    echo "To push that version (and other of the same repo):"
    echo "  docker push edyan/nginx"
fi
