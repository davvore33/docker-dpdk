A DPDK dockerfile.

Usage:
```
$:docker build .
$:docker run -it --privileged -v /sys/bus/pci/drivers:/sys/bus/pci/drivers -v /sys/kernel/mm/hugepages:/sys/kernel/mm/hugepages -v /sys/devices/system/node:/sys/devices/system/node -v /dev:/dev YOUR_IMAGE_ID
```
Then you will enter the container. Notice that **You need to config DPDK hugepages and DPDK ports in your host**.
For test the DPDK, you can run :
```shell
$:export RTE_SDK=/root/dpdk-16.04
$:export RTE_TARGET=x86_64-native-linuxapp-gcc
$:cd dpdk-16.04/example/helloworld
$:make
$:./build/helloworld
```

[A detail guide written in Chinese](http://blog.csdn.net/NachtZ/article/details/52832956)
