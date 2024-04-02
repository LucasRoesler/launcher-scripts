#!/bin/sh
#
# name: Update Rescrobbler
# icon: media-optical-symbolic
# description: Update the Rescrobbler player list
# keywords: lastfm rescrobbler scrobble

out=$(rescrobbler-update)
notify-send -t 100 -c device -i media-optical-symbolic "Added $out"
