#!/usr/bin/env bash
docker run -itd --privileged\
   	-v /sys/bus/pci/devices:/sys/bus/pci/devices\
   	-v /sys/kernel/mm/hugepages:/sys/kernel/mm/hugepages\
   	-v /sys/devices/system/node:/sys/devices/system/node\
   	-v /dev:/dev warp17
