#!/bin/bash

[ $# -lt 2 -o $# -gt 8  ] && \
  echo "Usage: $0 REPO IMAGE_URI [ -r REVISION] [-b BASE_DIR] [-d DOCKERFILE] [-n NAMESPACE] [-gs GIT_SECRET] [-as AWS_SECRET]" && exit 1


REPO="${1}"
IMAGE_URI="${2}"
shift; shift

REVISION="master"
DOCKERFILE="Dockerfile"
AWS_SECRET="aws-login"
GIT_SECRET="ssh-git-secret"

while [[ $# -gt 0 ]]
do
  case $1 in
    -r)
    REVISION=${2}
    shift; shift
    ;;
    -b)
    BASE_DIR=${2}
    shift; shift
    ;;
    -d)
    DOCKERFILE=${2}
    shift; shift
    ;;
    -n)
    NAMESPACE="-n ${2}"
    shift; shift
    ;;
    -gs)
    GIT_SECRET="${2}"
    shift; shift
    ;;
    -as)
    AWS_SECRET="${2}"
    shift; shift
    ;;
  esac
done

[ -z ${BASE_DIR} ] && \
  JOB="$(echo $(basename ${REPO} .git) | cut -c -63)" ||  \
  JOB="$(echo $(basename ${REPO} .git)-${BASE_DIR}-${REVISION} | cut -c -63)"

kubectl ${NAMESPACE} get job | grep "${JOB}" &>/dev/null && kubectl ${NAMESPACE} delete job ${JOB}

template="$(cat job.yaml)"
eval "echo \"${template}\"" | kubectl ${NAMESPACE} apply -f -
