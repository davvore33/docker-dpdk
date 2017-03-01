#!/bin/bash
################################################################################
#
#  build_dpdk.sh
#
#             - Build DPDK and pktgen-dpdk for 
#
#  Usage:     Adjust variables below before running, if necessary.
#
#  MAINTAINER:  jeder@redhat.com
#
#
################################################################################

################################################################################
#  Define Global Variables and Functions
################################################################################

URL=http://fast.dpdk.org/rel/dpdk-16.07.2.tar.xz
BASEDIR=/root
VERSION=16.07.2
PACKAGE=dpdk
DPDKROOT=$BASEDIR/$PACKAGE-stable-$VERSION
CONFIG=x86_64-native-linuxapp-gcc


# Download/Build DPDK
cd $BASEDIR
wget $URL
tar -xf $PACKAGE-$VERSION.tar.xz
cd $DPDKROOT
 sed -i 's/CONFIG_RTE_EAL_IGB_UIO=y/CONFIG_RTE_EAL_IGB_UIO=n/' ${DPDKROOT}/config/common_linuxapp \
  && sed -i 's/CONFIG_RTE_LIBRTE_KNI=y/CONFIG_RTE_LIBRTE_KNI=n/' ${DPDKROOT}/config/common_linuxapp \
  && sed -i 's/CONFIG_RTE_KNI_KMOD=y/CONFIG_RTE_KNI_KMOD=n/' ${DPDKROOT}/config/common_linuxapp
 
# don't build unnecessary stuff, can be reversed in dpdk_config.sh
sed -i 's/CONFIG_RTE_APP_TEST=y/CONFIG_RTE_APP_TEST=n/' ${DPDKROOT}/config/common_base \
  && sed -i 's/CONFIG_RTE_TEST_PMD=y/CONFIG_RTE_TEST_PMD=n/' ${DPDKROOT}/config/common_base \
  && sed -i 's/CONFIG_RTE_EAL_IGB_UIO=y/CONFIG_RTE_EAL_IGB_UIO=n/' ${DPDKROOT}/config/common_base \
  && sed -i 's/CONFIG_RTE_LIBRTE_IGB_PMD=y/CONFIG_RTE_LIBRTE_IGB_PMD=n/' ${DPDKROOT}/config/common_base \
  && sed -i 's/CONFIG_RTE_LIBRTE_IXGBE_PMD=y/CONFIG_RTE_LIBRTE_IXGBE_PMD=n/' ${DPDKROOT}/config/common_base

make config T=$CONFIG
sed -ri 's,(PMD_PCAP=).*,\1y,' build/.config
make 
make install

# Copy the provisioning script into our dbase dir
cp /root/provision.sh $DPDKROOT

# Download/Build pktgen-dpdk
#URL=http://dpdk.org/browse/apps/pktgen-dpdk/snapshot/pktgen-3.0.14.tar.xz
#BASEDIR=/root
#VERSION=3.0.14
#PACKAGE=pktgen
#PKTGENROOT=$BASEDIR/$PACKAGE-$VERSION
#cd $BASEDIR
#curl $URL | tar xz

# Silence compiler info message
#sed -i '/Wwrite-strings$/ s/$/ -Wno-unused-but-set-variable/' $DPDKROOT/mk/toolchain/gcc/rte.vars.mk
#cd $PKTGENROOT
#make
#ln -s $PKTGENROOT/app/app/$CONFIG/pktgen /usr/bin
