FROM registry.access.redhat.com/rhel7/rhel-tools
MAINTAINER NachtZ<nachtz@outlook.com>

LABEL "RUN docker run -it --privileged -v /sys/bus/pci/devices:/sys/bus/pci/devices -v /sys/kernel/mm/hugepages:/sys/kernel/mm/hugepages -v /sys/devices/system/node:/sys/devices/system/node -v /dev:/dev --name NAME -e NAME=NAME -e IMAGE=IMAGE IMAGE"

# Setup yum repos, or use subscription-manager
# Install DPDK support packages.
RUN yum install -y sudo libhugetlbfs-utils libpcap-devel \
    kernel kernel-devel kernel-headers
# RUN  apt-get update && apt-get install -y libpcap-dev \
#   wget \
#   xz-utils \
#   gcc \
#   automake \
#   autoconf \
#   libtool \
#   ethtool \
#   make \
#   python \
#   python-pip \
#   pciutils

# Build DPDK and pktgen-dpdk for x86_64-native-linuxapp-gcc.
WORKDIR /root
COPY ./build_dpdk.sh /root/build_dpdk.sh
COPY ./dpdk-profile.sh /etc/profile.d/
RUN chmod 777 /root/build_dpdk.sh
RUN /root/build_dpdk.sh

# Defaults to a bash shell, you could put your DPDK-based application here.
CMD ["/bin/bash"]
