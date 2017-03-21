FROM ubuntu:trusty
MAINTAINER NachtZ<nachtz@outlook.com>

LABEL "RUN docker run -it --privileged\
 -v /sys/bus/pci/devices:/sys/bus/pci/devices\
 -v /sys/kernel/mm/hugepages:/sys/kernel/mm/hugepages\
 -v /sys/devices/system/node:/sys/devices/system/node\
 -v /dev:/dev --name NAME -e NAME=NAME -e IMAGE=IMAGE IMAGE"

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
  ncurses-dev

RUN pip install --upgrade pip && \
    pip install pyelftools

    
# Build DPDK and pktgen-dpdk for x86_64-native-linuxapp-gcc.
WORKDIR /root
COPY ./build_dpdk.sh /root/build_dpdk.sh
COPY ./env.sh /root/env.sh
COPY ./provision.sh /root/provision.sh
COPY ./dpdk-profile.sh /etc/profile.d/
RUN chmod 777 /root/*.sh
RUN /root/build_dpdk.sh

# WARP17 part
ENV RTE_SDK /usr/local/share/dpdk
ENV RTE_TARGET x86_64-native-linuxapp-gcc
COPY ./build_warp17.sh /root/build_warp17.sh
RUN chmod 777 /root/*.sh
RUN /root/build_warp17.sh

# python dep
#RUN pip install virtualenv && \
#    virtualenv warp17-venv && \
#    source warp17-venv/bin/activate && \
#    pip install -r python/requirements.txt
#    
# Defaults to a bash shell, you could put your DPDK-based application here.
CMD ["/bin/bash"]
