FROM ubuntu:trusty
MAINTAINER Matteo<davvore33@gmail.com> 

# Define Env vars
ENV RTE_VER 17.11.3
ENV RTE_SDK /opt/dpdk-$RTE_VER
ENV RTE_TARGET x86_64-native-linuxapp-gcc


# Install DPDK support packages.
RUN apt update && apt upgrade -y
RUN apt install -y libpcap-dev \
  wget \
  git \
  xz-utils \
  build-essential \
  libtool \
  ethtool \
  python \
  python-pip \
  pciutils \
  kmod \
  net-tools \
  nano \
  hugepages \
  protobuf-compiler \
  libprotobuf-dev \ 
  python-protobuf \
  libprotobuf-c0 \
  libprotobuf-c0-dev \
  libprotobuf8 \
  libprotoc8 \
  protobuf-c-compiler \
  python-pip \
  unzip \
  libnuma-dev \
  ncurses-dev

RUN pip install --upgrade pip && \
    pip install pyelftools    
WORKDIR /root

# Getting warp17 from git repo
RUN git clone https://github.com/Juniper/warp17.git 

COPY ./build_dpdk.sh /root/build_dpdk.sh
COPY ./docker_patch.patch /root/docker_patch.patch
RUN chmod 777 /root/build_dpdk.sh
RUN /root/build_dpdk.sh -v $RTE_VER -i -j12

WORKDIR /root/warp17
# Build DPDK and pktgen-dpdk for x86_64-native-linuxapp-gcc.
#RUN ./build_dpdk.sh -v $RTE_VER -j 2 -i

# Defaults to a bash shell, you could put your DPDK-based application here.
CMD ["/bin/bash"]

