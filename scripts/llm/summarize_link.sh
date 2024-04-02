#! /bin/bash
#
# name: Summarize URL
# icon: org.gnome.Robots-symbolic
# description: Summarize a URL passed from the clipboard
# keywords: llm chatbot summary

# Summarize a web page using links and llm-cli
# the URL is passed from the clipboard

# get the URL from the clipboard using wl-paste or xclip

# check if the session is wayland and wl-paste is installed
# if not, check if it is X11 and xclip is installed
# if not, exit with an error message
if [ "$XDG_SESSION_TYPE" = "wayland" ]; then
    if ! command -v wl-paste &> /dev/null; then
        echo "wl-paste is not installed" >&2
        exit 1
    fi
    url=$(wl-paste -n)
elif [ "$XDG_SESSION_TYPE" = "x11" ]; then
    if ! command -v xclip &> /dev/null; then
        echo "xclip is not installed" >&2
        exit 1
    fi
    url=$(xclip -o)
else
    echo "This script only works on X11 and Wayland" >&2
    exit 1
fi

# check if links is installed
if ! command -v links &> /dev/null; then
    echo "links is not installed" >&2
    exit 1
fi

# check if llm-cli is installed
if ! command -v llm-cli &> /dev/null; then
    echo "llm-cli is not installed" >&2
    exit 1
fi

temp_file=$(mktemp --suffix=".md")
# summarize the web page using links and llm-cli and redirect to a random tmp file
links -codepage utf-8 -force-html -width 500 -dump "$url" \
| sed 's/ */ /g' \
| llm-cli prompt --streaming --system-prompt "Summarize the following text from $url, write the output in markdown." \
> "$temp_file"

# check if zenity is installed
if ! command -v zenity &> /dev/null; then
    cat "$temp_file"
    rm "$temp_file"
    exit 0
fi

zenity --icon=info \
       --width=800 \
       --height=600 \
       --text-info \
       --title="Response" \
       --filename=$temp_file

rm "$temp_file"