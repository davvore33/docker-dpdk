# this returns commands output
set -e

# getting warp17 from git repo, unzip and make
wget https://github.com/Juniper/warp17/archive/dev/common.zip
unzip common.zip
cd warp17-dev-common
make
