#!/bin/sh
#
# name: Toggle NordVPN
# icon: network-vpn-symbolic
# description: Toggle NordVPN
# keywords: vpn nordvpn

# if status contains Disconnected, then we connect to the vpn
if nordvpn status | grep Disconnected; then
    nordvpn connect romania
    notify-send -t 100 -c device -i network-vpn-symbolic "NordVPN" "Connected to romania"
else
    nordvpn disconnect
    notify-send -t 100 -c device -i network-vpn-disabled-symbolic "NordVPN" "Disconnected"
fi
