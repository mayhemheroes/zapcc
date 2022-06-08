FROM --platform=linux/amd64 ubuntu:20.04 as builder

RUN apt-get update
RUN DEBIAN_FRONTEND=noninteractive apt-get install -y build-essential ninja-build cmake
RUN DEBIAN_FRONTEND=noninteractive apt-get install -y python

ADD . /zapcc
WORKDIR /zapcc/build
RUN cmake -G Ninja -DCMAKE_BUILD_TYPE=Release -DLLVM_ENABLE_WARNINGS=OFF ..
RUN ninja

RUN mkdir -p /deps
RUN ldd /zapcc/build/bin/zapcc | tr -s '[:blank:]' '\n' | grep '^/' | xargs -I % sh -c 'cp % /deps;'

FROM ubuntu:20.04 as package

COPY --from=builder /deps /deps
COPY --from=builder /zapcc/build/bin/zapcc /zapcc/build/bin/zapcc
ENV LD_LIBRARY_PATH=/deps

WORKDIR /zapcc/build/bin
RUN echo "int main() { return 0; }" > ./test.c