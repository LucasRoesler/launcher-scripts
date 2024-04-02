#!/bin/sh
#
# name: Mute mic
# icon: microphone-sensitivity-muted-symbolic
# description: Toggle microphone
# keywords: mic microphone mute
amixer -D pulse set Capture toggle

