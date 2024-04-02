#!/bin/bash

# first check if an external monitor is plugged in

external_monitor=$(cat /sys/class/drm/card0-DP-1/status)

# Get the current default sink
current_sink=$(pactl get-default-sink)

# Get the list of all sinks
all_sinks=$(pactl list sinks short | cut -f 2)

# Find the index of the current sink in the list
current_index=$(echo "$all_sinks" | grep -nx "$current_sink" | cut -d ":" -f 1)

# Calculate the index of the next sink in the list
next_index=$((current_index % $(echo "$all_sinks" | wc -l) + 1))

# Get the name of the next sink
next_sink=$(echo "$all_sinks" | sed "${next_index}q;d")

if [ "$external_monitor" = "connected" ]; then
    if [ "$next_sink" == "alsa_output.pci-0000_00_1f.3.analog-stereo" ]; then
        # skip this sink
        next_index=$((next_index % $(echo "$all_sinks" | wc -l) + 1))
        next_sink=$(echo "$all_sinks" | sed "${next_index}q;d")
    fi
fi

# if next_sink

# # Set the next sink as the new default sink
pactl set-default-sink "$next_sink"

# Print the name of the new default sink
# Get the display name of the new sink
new_sink_info=$(pactl list sinks | grep -A 1 "Name: $next_sink")
new_sink_display_name=$(echo "$new_sink_info" | grep "Description:" | cut -d ":" -f 2 | sed 's/^\s*//;s/\s*$//')

echo "Switched default sink to: $new_sink_display_name"

notify-send -t 100 -c device -i multimedia-volume-control "Sound Output" "Changed to $new_sink_display_name"
