#!/bin/bash

VERSION="16.11.4"
FILE="dpdk-$VERSION.tar.xz"
URL=http://fast.dpdk.org/rel/$FILE
BASEDIR=/root
DPDKROOT=$BASEDIR/dpdk-$VERSION
CONFIG=x86_64-native-linuxapp-gcc


# Download/Build DPDK
cd $BASEDIR
wget $URL
mkdir $DPDKROOT
tar -xaf $FILE -C $DPDKROOT --strip-components=1
cd $DPDKROOT 
sed -i 's/CONFIG_RTE_EAL_IGB_UIO=y/CONFIG_RTE_EAL_IGB_UIO=n/' ${DPDKROOT}/config/common_linuxapp \
&& sed -i 's/CONFIG_RTE_KNI_KMOD=y/CONFIG_RTE_KNI_KMOD=n/' ${DPDKROOT}/config/common_linuxapp \
&& sed -i 's/CONFIG_RTE_LIBRTE_MLX5_PMD=n/CONFIG_RTE_LIBRTE_MLX5_PMD=y/' ${DPDKROOT}/config/common_base
 
# don't build unnecessary stuff, can be reversed in dpdk_config.sh
sed -i 's/CONFIG_RTE_APP_TEST=y/CONFIG_RTE_APP_TEST=n/' ${DPDKROOT}/config/common_base \
  && sed -i 's/CONFIG_RTE_TEST_PMD=y/CONFIG_RTE_TEST_PMD=n/' ${DPDKROOT}/config/common_base \
  && sed -i 's/CONFIG_RTE_EAL_IGB_UIO=y/CONFIG_RTE_EAL_IGB_UIO=n/' ${DPDKROOT}/config/common_base \
  && sed -i 's/CONFIG_RTE_LIBRTE_IGB_PMD=y/CONFIG_RTE_LIBRTE_IGB_PMD=n/' ${DPDKROOT}/config/common_base \
  && sed -i 's/CONFIG_RTE_LIBRTE_IXGBE_PMD=y/CONFIG_RTE_LIBRTE_IXGBE_PMD=n/' ${DPDKROOT}/config/common_base

make config T=$CONFIG
sed -ri 's,(PMD_PCAP=).*,\1y,' build/.config
#make 
make install T=$CONFIG
