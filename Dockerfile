FROM --platform=linux/amd64 ubuntu:20.04 

RUN apt-get update
RUN DEBIAN_FRONTEND=noninteractive apt-get install -y build-essential ninja-build cmake
RUN DEBIAN_FRONTEND=noninteractive apt-get install -y python

ADD . /zapcc
WORKDIR /zapcc/build
RUN cmake -G Ninja -DCMAKE_BUILD_TYPE=Release -DLLVM_ENABLE_WARNINGS=OFF ..
RUN ninja

WORKDIR /zapcc/build/bin

ADD ./test.c /zapcc/build/bin
