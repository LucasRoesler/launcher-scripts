#! /bin/bash
#
# name: Summarize
# icon: org.gnome.Robots-symbolic
# description: Summarize content passed from the clipboard
# keywords: llm chatbot summary

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

# check if llm-cli is installed
if ! command -v llm-cli &> /dev/null; then
    echo "llm-cli is not installed" >&2
    exit 1
fi

# check if zenity is installed
has_zenity=false
if command -v zenity &> /dev/null; then
    has_zenity=true
fi

temp_file=$(mktemp --suffix=".md")
if [ "$has_zentiy" = true ]; then
    zentify --notification --text="Summarizing content from the clipboard, thinking ..."
fi

# prompt and send all stderr and stdout to temp_file
llm-cli prompt --streaming --template summarizer -c 2>&1 > "$temp_file"
status=$?

# check if zenity is installed
if [ "$has_zentiy" = false ]; then
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