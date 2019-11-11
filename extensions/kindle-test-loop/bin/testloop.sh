#!/bin/sh

cd "$(dirname "$0")"

/etc/init.d/framework stop
/etc/init.d/powerd stop
/etc/init.d/cmd stop
/etc/init.d/phd stop
/etc/init.d/volumd stop
/etc/init.d/lipc-daemon stop
/etc/init.d/tmd stop
/etc/init.d/webreaderd stop
/etc/init.d/browserd stop
killall lipc-wait-event
/etc/init.d/pmond stop
/etc/init.d/cron stop

sleep 5

/usr/sbin/eips -c
/usr/sbin/eips -c
/usr/sbin/eips 15  4 'TESTING BATTERY LIFE'
sleep 1
/usr/sbin/eips 12  6 'WAKING UP EVERY 15 MINUTES'
sleep 1
/usr/sbin/eips 10 10 '---------- STARTING ----------'
sleep 1
/usr/sbin/eips 20 14 'START TIME'
sleep 1
/usr/sbin/eips  8 15 "$(date)"
sleep 1
/usr/sbin/eips 19 17 'CURRENT TIME'
sleep 1
/usr/sbin/eips 16 22 'START BATT PERCENT'
sleep 1
/usr/sbin/eips 24 23 "$(cat /sys/devices/system/yoshi_battery/yoshi_battery0/battery_capacity)"
sleep 1
/usr/sbin/eips 15 25 'CURRENT BATT PERCENT'
sleep 1
/usr/sbin/eips 16 28 'START BATT VOLTAGE'
sleep 1
/usr/sbin/eips 22 29 "$(cat /sys/devices/system/yoshi_battery/yoshi_battery0/battery_voltage)"
sleep 1
/usr/sbin/eips 26 29 'mV'
sleep 1
/usr/sbin/eips 15 31 'CURRENT BATT VOLTAGE'
sleep 1
/usr/sbin/eips 26 32 'mV'
sleep 1
/usr/sbin/eips 16 34 'BATT VOLTAGE RANGE'
sleep 1
/usr/sbin/eips 15 35 "$(cat /sys/devices/system/yoshi_battery/yoshi_battery0/battery_voltage_thresholds)"
sleep 1

while true
do
    /usr/sbin/eips 22 39  '      '
    /usr/sbin/eips 10 10 '========== UPDATING =========='
    /usr/sbin/eips  8 18 '                                  '
    /usr/sbin/eips 24 26 '   '
    /usr/sbin/eips 22 32 '    '
    
    # Detect if home button is pressed, and reboot the device accordingly
    ./evtest-jessie-armel /dev/input/event0 > /tmp/event0.dmp & sleep 5 ; kill $!
    wait
    if grep -q "type 1 (EV_KEY), code 102 (KEY_HOME), value 1" /tmp/event0.dmp; then
        /sbin/reboot
    fi
    
    # Always reconnect to wlan with wpa_cli and wait for 5 seconds
    # Courtesy of https://www.mobileread.com/forums/showthread.php?t=312150
    /usr/bin/wpa_cli -i wlan0 reconnect
    sleep 5
    
    # Test network status
    ping -c 5 www.microsoft.com
    PINGSTATUS=$?
    if [ $PINGSTATUS -ne 0 ]; then
        /usr/sbin/eips 10 10 '**** NETWORK DISCONNECTED ****'
    else
        /usr/sbin/eips 10 10 '     NETWORK IS AVAILABLE     '
        # Why not update the time when network is available?
        /usr/bin/ntpdate -s pool.ntp.org
    fi
    
    sleep 15

    # Update display fields
    /usr/sbin/eips  8 18 "$(date)"
    /usr/sbin/eips 24 26 "$(cat /sys/devices/system/yoshi_battery/yoshi_battery0/battery_capacity)"
    /usr/sbin/eips 22 32 "$(cat /sys/devices/system/yoshi_battery/yoshi_battery0/battery_voltage)"
    
    sleep 5

    # Set wakeup alarm then back to sleep
    echo "" > /sys/class/rtc/rtc1/wakealarm
    echo "+900" > /sys/class/rtc/rtc1/wakealarm
    /usr/sbin/eips 22 39  'zzz...'
    echo mem > /sys/power/state
done