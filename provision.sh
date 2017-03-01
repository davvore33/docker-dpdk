#!/bin/sh
#
# This script downloads, installs and configure the Intel DPDK framework
# on a clean Ubuntu 14.04 installation running in a virtual machine.
#
# This script has been created based on the following scripts:
#  * https://gist.github.com/ConradIrwin/9077440
#  * http://dpdk.org/doc/quick-start

# Path to the build dir
export RTE_SDK=`pwd`

# Target of build process
export RTE_TARGET=x86_64-native-linuxapp-gcc

# Configure hugepages
# You can later check if this change was successful with `cat /proc/meminfo`
# Hugepages setup should be done as early as possible after boot
HUGEPAGE_MOUNT=/mnt/huge
echo 1024 | tee /sys/kernel/mm/hugepages/hugepages-2048kB/nr_hugepages
mkdir ${HUGEPAGE_MOUNT}
mount -t hugetlbfs nodev ${HUGEPAGE_MOUNT}
# Set Hugepages in /etc/fstab so they persist across reboots
echo "hugetlbfs ${HUGEPAGE_MOUNT} hugetlbfs rw,mode=0777 0 0" | tee -a /etc/fstab

# Install kernel modules
modprobe uio
insmod ${RTE_SDK}/build/kmod/igb_uio.ko

# Make uio and igb_uio installations persist across reboots
ln -s ${RTE_SDK}/build/kmod/igb_uio.ko /lib/modules/`uname -r`
depmod -a
echo "uio" | tee -a /etc/modules
echo "igb_uio" | tee -a /etc/modules

# Bind secondary network adapter
# I need to set a second adapter in Vagrantfile
# Note: NIC setup does not persist across reboots
# sudo ifconfig eth1 down
# sudo ${RTE_SDK}/tools/dpdk_nic_bind.py --bind=igb_uio eth1

# Add env variables setting to .profile file so that they are set at each login
echo "export RTE_SDK=${RTE_SDK}" >> ${HOME}/.profile
echo "export RTE_TARGET=${RTE_TARGET}" >> ${HOME}/.profile

# We need to do this to make the examples compile, not sure why.
ln -s ${RTE_SDK}/build ${RTE_SDK}/${RTE_TARGET}