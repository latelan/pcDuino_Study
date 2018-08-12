#!/bin/bash
#
# Let pcDuino connect to the wifi
#
# by abel. 2017.07.22

INTERFACE=ra0
ESSID=""
DEVICE_IDS=(
    '148f:760b'     # 360 wifi
)

check_device() {
    echo "Check deive:"
    for id in ${DEVICE_IDS[@]}; do
        lsusb | grep $id
        if [ $? -eq 0 ]; then
            return 0;
        fi
    done

    echo "No device found."
    exit 1
}

check_wifi() {
    echo "Check wifi:"
    iwlist $INTERFACE scanning | grep $ESSID
    if [ $? -eq 0 ]; then
        return 0
    fi

    echo "Can not found the wifi: $ESSID."
    exit 1  
}

main() {
    # check device
    check_device
    # check wifi
    check_wifi
    # connect to the wifi
    wpa_supplicant -i $INTERFACE -B -c /etc/wpa_supplicant/wpa_supplicant.conf -D wext
    # get ip address after 5 seconds
    sleep 5
    dhclient $INTERFACE
}

main
