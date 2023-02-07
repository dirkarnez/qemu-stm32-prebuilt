FROM ubuntu:20.04

# USER docker
RUN apt-get update -y && \
   apt-get upgrade -y && \
   apt-get dist-upgrade -y && \
   apt-get install software-properties-common -y && \
   add-apt-repository ppa:ubuntu-toolchain-r/test -y && \
   apt-get update -y && \
   apt-get -y --no-install-recommends --allow-unauthenticated install \
   build-essential \
   git \
   apt-utils \
   gcc-11 \
   g++-11 \
   libstdc++-11-dev \
   zip \
   unzip \
   wget \
   apt-transport-https \
   ca-certificates \
   autotools-dev \
   autoconf \
   make \
   libtool \
   xz-utils \
   curl \
   && \
   update-alternatives --install /usr/bin/gcc gcc /usr/bin/gcc-11 60 --slave /usr/bin/g++ g++ /usr/bin/g++-11 && \
   update-alternatives --config gcc \
   && \
   apt-get clean && \
   rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

RUN curl -SL http://releases.llvm.org/7.0.1/clang+llvm-7.0.1-x86_64-linux-gnu-ubuntu-16.04.tar.xz | tar -xJC .  && \
   cp -r clang+llvm-7.0.1-x86_64-linux-gnu-ubuntu-16.04/ /usr/local/clang-7.0.1  && \
   export LD_LIBRARY_PATH=/usr/local/clang-7.0.1/lib:$LD_LIBRARY_PATH && \
   export PATH=/usr/local/clang-7.0.1/bin:$PATH && \
   ldconfig

RUN mkdir -p /src/workspace
VOLUME mkdir -p /tmp/build_output

VOLUME /src/workspace
VOLUME /tmp/build_output

#   git submodule update --init --recursive && \

CMD cd /src/workspace && \
   git clone --recursive https://github.com/beckus/qemu_stm32.git && \
   cd qemu_stm32 && \
   git checkout stm32_v0.1.3 && \
   ./configure --enable-debug --target-list="arm-softmmu" --prefix=/tmp/build_output && \
   make && \
   cd /tmp/build_output && \
   zip --symlinks -r qemu-stm32-v0.1.3.zip . && \
   exit
