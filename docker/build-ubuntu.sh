#!/bin/bash
set -e

test -e docker/fetch.sh || {
	echo This script must be run from the top level of the AliceVision tree
	exit 1
}

#export AV_DEPS_VERSION=2025.03.27
#export AV_VERSION=v3.2.0
#export CUDA_VERSION=12.1.1
#export UBUNTU_VERSION=22.04


test -z "$AV_DEPS_VERSION" && AV_DEPS_VERSION=2025.03.27
#test -z "$AV_VERSION" && AV_VERSION="$(git rev-parse --abbrev-ref HEAD)-$(git rev-parse --short HEAD)"
test -z "$AV_VERSION" && AV_VERSION=v3.2.0
test -z "$CUDA_VERSION" && CUDA_VERSION=12.1.1
test -z "$UBUNTU_VERSION" && UBUNTU_VERSION=22.04
test -z "$REPO_OWNER" && REPO_OWNER=alicevision
test -z "$DOCKER_REGISTRY" && DOCKER_REGISTRY=docker.io
test -z "$AV_BUNDLE" && AV_BUNDLE=/opt/AliceVision_bundle

./docker/fetch.sh

#DEPS_DOCKER_TAG=${REPO_OWNER}/alicevision-deps:${AV_DEPS_VERSION}-centos${CENTOS_VERSION}-cuda${CUDA_VERSION}
DEPS_DOCKER_TAG=${REPO_OWNER}/alicevision-deps:${AV_DEPS_VERSION}-ubuntu${UBUNTU_VERSION}-cuda${CUDA_VERSION}

## DEPENDENCIES
docker build \
	--build-arg AV_BUNDLE=${AV_BUNDLE} \
	--build-arg CUDA_VERSION=${CUDA_VERSION} \
	--build-arg UBUNTU_VERSION=${UBUNTU_VERSION} \
	--tag alicevision/alicevision-deps:${AV_VERSION}-ubuntu${UBUNTU_VERSION}-cuda${CUDA_VERSION} \
	-f docker/Dockerfile_ubuntu_deps .

echo ""
echo "  To upload results:"
echo "docker push ${DEPS_DOCKER_TAG}"
echo ""

DOCKER_TAG=${REPO_OWNER}/alicevision:${AV_VERSION}-centos${CENTOS_VERSION}-cuda${CUDA_VERSION}

## ALICEVISION
docker build \
	--build-arg AV_BUNDLE=${AV_BUNDLE} \
	--build-arg CUDA_VERSION=${CUDA_VERSION} \
	--build-arg UBUNTU_VERSION=${UBUNTU_VERSION} \
	--build-arg AV_VERSION=${AV_VERSION} \
	--build-arg AV_DEPS_VERSION=${AV_DEPS_VERSION} \
	--tag alicevision/alicevision:${AV_VERSION}-ubuntu${UBUNTU_VERSION}-cuda${CUDA_VERSION} \
	-f docker/Dockerfile_ubuntu .

echo ""
echo "  To upload results:"
echo ""
echo "docker push ${DEPS_DOCKER_TAG}"
echo "docker push ${DOCKER_TAG}"
echo ""
