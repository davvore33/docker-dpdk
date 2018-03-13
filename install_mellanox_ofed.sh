#!/bin/bash
BASEDIR="/root"
MLX_DIR="MLNX_OFED_LINUX-3.4-1.0.0.0-ubuntu14.10-x86_64"
set -e

cd $BASEDIR
wget http://www.mellanox.com/downloads/ofed/MLNX_OFED-3.4-1.0.0.0/$MLX_DIR.tgz
tar -xaf $MLX_DIR.tgz
cd $MLX_DIR
echo "ubuntu14.04" > distro 
if [[ $USER != 'root' ]]; then
    sudo ./mlnxofedinstall -q
else
    ./mlnxofedinstall -q
fi
