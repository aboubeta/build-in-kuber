## Setup 
### Git private repo

* Add the public key to you app repo
* Create secret ssh-git-secret with you privat key:

```
kubectl create secret generic ssh-git-secret --from-file=id_rsa=ssh_priv_key
```

### Private registry
#### AWS ECR
* If you use AWS ECR registry, you need aws-login with AWS_ACCESS_KEY_ID, AWS_SECRET_ACCESS_KEY, AWS_DEFAULT_REGION keys:

```
kubectl create secret generic aws-login \
  --from-literal=AWS_ACCESS_KEY_ID=${AWS_ACCESS_KEY_ID} \
  --from-literal=AWS_SECRET_ACCESS_KEY=${AWS_SECRET_ACCESS_KEY} \
  --from-literal=AWS_DEFAULT_REGION=${AWS_DEFAULT_REGION}
```


#### Other registries (Docker Hub, Azure, Gitlab, ...)
```
kubectl create secret generic docker-login   --from-literal=user=${DOCKER_USER} --from-literal=pass=${DOCKER_PASSWORD}
```


## Launch job

```
./create-job.sh REPO IMAGE_URI [ -r REVISION] [-b BASE_DIR] [-d DOCKERFILE] [-n NAMESPACE] [-gs GIT_SECRET] [-as AWS_SECRET] [-ds DOCKER_SECRET]
```

```
REPO: Git repository
IMAGE_URI: Docker registry image URL (ex. centos/tools or registry.gitlab.com/boube/netdata)
REVISION: Git branch or commit
BASE_DIR: Docker context directory
DOCKERFILE: Dockerfile file path (relative to BASE_DIR)
NAMESPACE: Kubernetes namespace where the job will run
GIT_SECRET: SSH public key in Kubernetes
AWS_SECRET: Amazon AWS credentials secret in Kubernetes
```

### Examples

* Simple:

```
./create-job.sh git@gitlab.com:boube/build-in-kuber.git registry.gitlab.com/boube/build-in-kuber
```

* With branch or commit:

```
./create-job.sh git@gitlab.com:boube/build-in-kuber.git registry.gitlab.com/boube/build-in-kuber -r develop
./create-job.sh git@gitlab.com:boube/build-in-kuber.git registry.gitlab.com/boube/build-in-kuber -r 11e6007adff0f84053761b7df6855cc01d5cdd96
```

* With all options:

```
./create-job.sh \
  git@gitlab.com:boube/build-in-kuber.git \
  registry.gitlab.com/boube/build-in-kuber \
  -r 11e6007adff0f84053761b7df6855cc01d5cdd96 \
  -b dir
  -d dockerfiles/Dockefile
  -n ci-cd
  -gs ssh-git-secret
  -as aws-login
```

## TODO 

* Job template: Optional AWS_SECRET
* Tests
* CI/CD
* Support other private registries (Azure, DockerHub, Gitlab )

Inspired on https://github.com/containerbuilding/cbi
