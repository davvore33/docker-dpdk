FROM ubuntu:xenial
MAINTAINER Matteo<davvore33@gmail.com> 

# Install DPDK support packages.

RUN apt update && apt upgrade -y
RUN apt install -y libpcap-dev \
  sudo \
  wget \
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
  python-pip \
  unzip \
  ncurses-dev
COPY install_compatibility_pkg.sh /root/install_compatibility_pkg.sh
RUN chmod 777 /root/*.sh && \
    /root/install_compatibility_pkg.sh

RUN pip install --upgrade pip && \
    pip install pyelftools

    
# Build DPDK and pktgen-dpdk for x86_64-native-linuxapp-gcc.
WORKDIR /root
RUN mkdir /mnt/huge
#    mount -t hugetlbfs nodev /mnt/huge
COPY ./build_dpdk.sh /root/build_dpdk.sh
RUN chmod 777 /root/*.sh && \
    /root/build_dpdk.sh

# WARP17 part
ENV RTE_SDK /root/dpdk-16.11
ENV RTE_TARGET x86_64-native-linuxapp-gcc
#/usr/local/share/dpdk
COPY ./build_warp17.sh /root/build_warp17.sh
RUN chmod 777 /root/*.sh && \
    /root/build_warp17.sh


# Defaults to a bash shell, you could put your DPDK-based application here.
CMD ["/bin/bash"]
