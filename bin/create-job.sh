#!/bin/bash

[ -z ${DEBUG} ] || set +x



JDIR="$(dirname $0)/../templates"

REPO="${1}"
IMAGE_URI="${2}"
shift; shift


[ -z  ${REPO} -o -z ${IMAGE_URI}  ] && \
  echo "Usage: $0 REPO IMAGE_URI [ -r REVISION] [-b BASE_DIR] [-d DOCKERFILE] [-n NAMESPACE] [-gs GIT_SECRET] [-as AWS_SECRET] [-ds DOCKER_SECRET]" && exit 1

REVISION="master"
DOCKERFILE="Dockerfile"

unset BASE_DIR NAMESPACE  GIT_SECRET AWS_SECRET DOCKER_SECRET

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
    -ds)
    DOCKER_SECRET="${2}"
    shift; shift
    ;;
  esac
done



[ -z ${BASE_DIR} ] && \
  JOB="$(echo $(basename ${REPO} .git) | cut -c -63)" ||  \
  JOB="$(echo $(basename ${REPO} .git)-$(echo ${BASE_DIR} | sed 's#/$##g')-${REVISION} | cut -c -63)"

#kubectl ${NAMESPACE} get job | grep "${JOB}" &>/dev/null && kubectl ${NAMESPACE} delete job ${JOB}

template="$(cat ${JDIR}/job.yaml)"
eval "echo \"${template}\"" | kubectl ${NAMESPACE} apply -f -

#template="$(cat ${JDIR}pod.yaml)"
#eval "echo \"${template}\"" 
