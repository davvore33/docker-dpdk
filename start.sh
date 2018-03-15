#!/bin/bash
mt_pts="-v /dev/hugepages:/dev/hugepages \
	-v /:/mnt/chroot"
exec sudo docker run -ti --rm $mt_pts warp17 /bin/bash
