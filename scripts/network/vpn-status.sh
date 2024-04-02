#!/bin/sh
#
# name: NordVPN Status
# icon: network-vpn-symbolic
# description: NordVPN Current Status
# keywords: vpn nordvpn

# if status contains Disconnected, then we connect to the vpn
status=$(nordvpn status | grep Status) 
if status | grep Disconnected; then
    notify-send -t 100 -c device -i network-vpn-symbolic "NordVPN" "$status"
else
    notify-send -t 100 -c device -i network-vpn-disabled-symbolic "NordVPN" "$status"
fi
