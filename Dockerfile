# Build Stage
FROM --platform=linux/amd64 ubuntu:20.04 as builder
# SHELL ["/bin/bash", "-c"]
RUN apt-get update
RUN DEBIAN_FRONTEND=noninteractive apt-get install  -y vim less man wget tar git gzip unzip make cmake software-properties-common
RUN DEBIAN_FRONTEND=noninteractive apt-get install  -y ninja-build g++

ADD . /zapcc
WORKDIR /zapcc/build
RUN cmake -G Ninja -DCMAKE_BUILD_TYPE=Release -DLLVM_ENABLE_WARNINGS=OFF ..
RUN ninja

WORKDIR /zapcc/build/bin

ADD ./test.c /zapcc/build/bin
