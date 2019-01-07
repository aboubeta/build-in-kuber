#!/bin/bash -xe


[ -z ${REPO} ] && echo "REPO needs to be set (string)" && exit 1
[ -z ${IMAGE_URI} ] && echo "IMAGE_URI needs to be set (string)" && exit 1

[ -z ${REVISION} ] && REVISION="master"
[ -z ${DOCKERFILE} ] && DOCKERFILE="Dockerfile"

## Git
GIT_SSH_COMMAND="ssh -o UserKnownHostsFile=/dev/null -o StrictHostKeyChecking=no" git clone ${REPO} src
cd src/ && git checkout ${REVISION}
[ -z ${BASE_DIR} ] || cd ${BASE_DIR}

## Build
docker build -t ${IMAGE_URI} -f ${DOCKERFILE} .
[ -z ${AWS_ACCESS_KEY_ID} ] || $(aws ecr get-login | sed 's/\-e none//g' | sed 's/\r//g')
docker push ${IMAGE_URI}
