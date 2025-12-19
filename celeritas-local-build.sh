#!/bin/sh -ex
#-------------------------------- -*- sh -*- ---------------------------------#
# Copyright Celeritas contributors: see top-level COPYRIGHT file for details
# SPDX-License-Identifier: (Apache-2.0 OR MIT)
#-----------------------------------------------------------------------------#

if ! command -v celerlog >/dev/null 2>&1 ; then
  printf "error: no celerlog command defined\n" >&2
  exit 1
fi

if ! [ -d "$SCRATCHDIR" ]; then
  celerlog error "no scratch directory at '$SCRATCHDIR'"
  exit 1
fi

. spack.sh
. spack-packages.sh

# FIXME: I don't think this is the right place?
mkdir -p ~/.cache/eic-containers/{apt,spack,ccache}

docker buildx build \
  -f containers/debian/Dockerfile \
  --cache-from type=registry,ref=ghcr.io/eic/buildcache:debian_stable_base-master-amd64 \
  --build-arg jobs=64 \
  -t debian_stable_base:local \
  containers/debian