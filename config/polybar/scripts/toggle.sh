#!/usr/bin/env bash

BAR_PID="$1"

if [[ -s /tmp/bottom-mpd-status.log ]]; then
    STATUS=$(cat /tmp/bottom-mpd-status.log)
else
    STATUS="visible"
fi

case "$STATUS" in
    hidden)
        polybar-msg -p "$BAR_PID" cmd show
        bspc config -m "$MONITOR_MAIN" bottom_padding 44
        echo 'visible' > /tmp/bottom-mpd-status.log
        echo ''
        ;;
    visible)
        polybar-msg -p "$BAR_PID" cmd hide
        bspc config -m "$MONITOR_MAIN" bottom_padding 0
        echo 'hidden' > /tmp/bottom-mpd-status.log
        echo ''
        ;;
    *)
        echo 'error: invalid parameters'
        ;;
esac
