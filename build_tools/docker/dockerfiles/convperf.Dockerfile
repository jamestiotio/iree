# Copyright 2021 The IREE Authors
#
# Licensed under the Apache License v2.0 with LLVM Exceptions.
# See https://llvm.org/LICENSE.txt for license information.
# SPDX-License-Identifier: Apache-2.0 WITH LLVM-exception

# An image for running `convperf`: https://github.com/nod-ai/convperf.
#
# `convperf` benchmarks convolution workloads on IREE and other backends such
# as libxsmm. IREE is included as a submodule.

FROM gcr.io/iree-oss/perf@sha256:0e1c92dde6ec7312c7c92a8ee329892ad83bae4b7968e4f2c98f99ffad3faa48

######## OpenMP ########
RUN apt-get update \
    && apt-get install -y libomp-14-dev
##############

######## ConvPerf ########
COPY build_tools/docker/context/setup_convperf.sh /usr/local/bin

ARG CONVPERF_SHA="ca181bf9f1b959477acf8043eb5b5579fc47a37f"

# Generate a version of mmperf for CPU.
RUN mkdir -p "/usr/local/src/convperf" \
    && /usr/local/bin/setup_convperf.sh "/usr/local/src/convperf" "${CONVPERF_SHA}"

ENV CONVPERF_REPO_DIR="/usr/local/src/convperf/convperf"
############## \
