#!/bin/bash

url="http://ftp.iinet.net.au/pub/ubuntu/pool"
ROOT=/
tmp_folder=$ROOT/tmp
install_folder=$PWD
set -e
pkgs="
        /main/p/protobuf/libprotobuf8_2.5.0-9ubuntu1_amd64.deb      \
        /universe/p/protobuf-c/libprotobuf-c0_0.15-1build1_amd64.deb      \
        /universe/p/protobuf-c/libprotobuf-c0-dev_0.15-1build1_amd64.deb  \
        /main/p/protobuf/libprotobuf-dev_2.5.0-9ubuntu1_amd64.deb   \
        /main/p/protobuf/libprotobuf-lite8_2.5.0-9ubuntu1_amd64.deb \
        /main/p/protobuf/libprotoc8_2.5.0-9ubuntu1_amd64.deb        \
        /universe/p/protobuf-c/protobuf-c-compiler_0.15-1build1_amd64.deb \
        /main/p/protobuf/protobuf-compiler_2.5.0-9ubuntu1_amd64.deb"
        

tmp_pkg=$tmp_folder/pkg
echo creating folder $tmp_pkg for packages
mkdir $tmp_pkg
cd $tmp_pkg
for pkg in $pkgs
do
        echo downloading $pkg
        wget $url$pkg
done
echo installing packages
sudo dpkg -i *.deb
cd ../
rm -rf $tmp_pkg
