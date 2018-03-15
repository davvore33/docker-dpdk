#!/bin/bash
BASEDIR="/root"
VER="MLNX_OFED_LINUX-3.4-1.0.0.0"
MLX_DIR="$VER-ubuntu14.04-x86_64"
set -e

cd $BASEDIR
wget http://www.mellanox.com/downloads/ofed/MLNX_OFED-3.4-1.0.0.0/MLNX_OFED_LINUX-3.4-1.0.0.0-ubuntu14.04-x86_64.tgz
#wget http://www.mellanox.com/downloads/ofed/$VER/$MLX_DIR.tgz
tar -xaf $MLX_DIR.tgz
cd $MLX_DIR
echo "ubuntu14.04" > distro 
./mlnxofedinstall -q --dpdk

