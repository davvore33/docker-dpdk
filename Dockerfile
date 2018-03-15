FROM ubuntu:trusty
MAINTAINER Matteo<davvore33@gmail.com> 

# Install DPDK support packages.

RUN apt update && apt upgrade -y
RUN apt install -y libpcap-dev \
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
  libprotobuf-c0 \
  libprotobuf-c0-dev \
  libprotobuf8 \
  libprotoc8 \
  protobuf-c-compiler \
  python-pip \
  unzip \
  ncurses-dev \
  flex \
  libnuma1 \
  libgfortran3 \
  autoconf \
  quilt \
  curl \
  m4 \
  graphviz \
  tk8.4 \
  automake \
  pkg-config \
  gfortran \
  python-libxml2 \
  tk \
  debhelper \
  dkms \
  tcl8.4 \
  libnl1 \
  tcl \
  libglib2.0-0 \
  chrpath \
  dpatch \
  bison \
  swig \
  lsof \
  linux-headers-generic
RUN pip install --upgrade pip && \
    pip install pyelftools

    
# Build DPDK and pktgen-dpdk for x86_64-native-linuxapp-gcc.
WORKDIR /root
RUN mkdir /mnt/huge
#    mount -t hugetlbfs nodev /mnt/huge
RUN wget http://launchpadlibrarian.net/321054959/linux-headers-4.8.0-54_4.8.0-54.57~16.04.1_all.deb \
    && wget http://launchpadlibrarian.net/321054957/linux-headers-4.8.0-54-generic_4.8.0-54.57~16.04.1_amd64.deb \
    && dpkg -i linux-headers-4.8.0-54-generic_4.8.0-54.57~16.04.1_amd64.deb    linux-headers-4.8.0-54_4.8.0-54.57~16.04.1_all.deb 

ADD . /etc
ADD . /usr
ADD . /var
add . /lib
ADD . /sys
COPY ./install_mellanox_ofed.sh /root/install_mellanox_ofed.sh
RUN chmod 777 /root/*.sh && \
    /root/install_mellanox_ofed.sh
    
COPY ./build_dpdk.sh /root/build_dpdk.sh
RUN chmod 777 /root/*.sh && \
    /root/build_dpdk.sh

# WARP17 part
ENV RTE_SDK /root/dpdk-16.11.4
ENV RTE_TARGET x86_64-native-linuxapp-gcc
#/usr/local/share/dpdk
COPY ./build_warp17.sh /root/build_warp17.sh
RUN chmod 777 /root/*.sh && \
    /root/build_warp17.sh

# Defaults to a bash shell, you could put your DPDK-based application here.
CMD ["/bin/bash"]
