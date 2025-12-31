#!/bin/bash -ex
#-------------------------------- -*- sh -*- ---------------------------------#
# Build Celertias docker images
# based on instructions in docs/building-locally.md
# and the CI job 

. ./spack.sh
. ./spack-packages.sh

BASE_IMAGE=debian:trixie-slim
BUILD_IMAGE=debian_stable_base
INTERNAL_TAG=local
PLATFORM=linux/amd64
JOBS=64
CI_COMMIT_REF_SLUG=spack-${SPACK_VERSION}

# Build base image

docker buildx build \
  --progress plain \
  --platform ${PLATFORM} \
  --build-arg BASE_IMAGE=${BASE_IMAGE} \
  --build-arg BUILD_IMAGE=${BUILD_IMAGE} \
  --build-arg SPACK_ORGREPO=${SPACK_ORGREPO} \
  --build-arg SPACK_VERSION=${SPACK_VERSION} \
  --build-arg SPACK_SHA=$(sh .ci/resolve_git_ref "${SPACK_ORGREPO}" "${SPACK_VERSION}") \
  --build-arg SPACK_CHERRYPICKS="${SPACK_CHERRYPICKS}" \
  --build-arg SPACK_CHERRYPICKS_FILES="${SPACK_CHERRYPICKS_FILES}" \
  --build-arg SPACKPACKAGES_ORGREPO=${SPACKPACKAGES_ORGREPO} \
  --build-arg SPACKPACKAGES_VERSION=${SPACKPACKAGES_VERSION} \
  --build-arg SPACKPACKAGES_SHA=$(sh .ci/resolve_git_ref "${SPACKPACKAGES_ORGREPO}" "${SPACKPACKAGES_VERSION}") \
  --build-arg SPACKPACKAGES_CHERRYPICKS="${SPACKPACKAGES_CHERRYPICKS}" \
  --build-arg SPACKPACKAGES_CHERRYPICKS_FILES="${SPACKPACKAGES_CHERRYPICKS_FILES}" \
  --build-arg jobs=${JOBS} \
  --cache-from type=registry,ref=ghcr.io/eic/buildcache:${BUILD_IMAGE}-${CI_COMMIT_REF_SLUG}-amd64 \
  --tag ${BUILD_IMAGE}:${INTERNAL_TAG} \
  -f containers/debian/Dockerfile \
  containers/debian