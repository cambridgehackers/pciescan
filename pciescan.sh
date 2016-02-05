#!/bin/bash
set -x
PATH=$PATH:/sbin
# invalidate existing device (so that scan will look for new one)
for devid in 1be7:c100 1be7:b100; do
    BLUEDEVICE=`lspci -d $devid | sed -e "s/ .*//"`
    if [ "$BLUEDEVICE" != "" ]; then
        sh -c "echo 1 >/sys/bus/pci/devices/0000:$BLUEDEVICE/remove"
    fi
done
#sh -c "echo 1 >/sys/bus/pci/devices/0000:01:00.0/remove"
# remove existing driver, since there is some bug in the 'remove'
# function, causing the driver to become unmapped although
# it is still registered (and causing a segv on the probe call)
sleep 1
(lsmod | grep -q pcieportal) && rmmod pcieportal
(lsmod | grep -q bluenoc) && rmmod pcieportal
sleep 1
sh -c "echo 1 >/sys/bus/pci/rescan"
sleep 1
#lspci -vv -d 1be7:c100
