#!/usr/bin/env bash

# If there is only one argument it should be the bar PID, so I save it.
if [[ $# == 1 ]]; then
    BAR_PID="$1"
    echo "$BAR_PID" > /tmp/bottom-mpd-pid
    exit 0
fi

# Otherwise (no args), I first extract the current bar status...
if [[ -s /tmp/bottom-mpd-status.log ]]; then
    STATUS=$(cat /tmp/bottom-mpd-status.log)
else
    STATUS="visible"
fi

# ... and then the bar PID.
if [[ -s /tmp/bottom-mpd-pid ]]; then
    BAR_PID=$(cat /tmp/bottom-mpd-pid)
else
    echo 'error: unknown pid'
    exit 1
fi

MONITOR_MAIN=$(xrandr -q | grep 'primary' | cut -d ' ' -f 1)

# And finally I toggle the bar based on the current status.
case "$STATUS" in
    hidden)
        polybar-msg -p "$BAR_PID" cmd show
        bspc config -m "$MONITOR_MAIN" bottom_padding 44
        echo 'visible' > /tmp/bottom-mpd-status.log
        ;;
    visible)
        polybar-msg -p "$BAR_PID" cmd hide
        bspc config -m "$MONITOR_MAIN" bottom_padding 0
        echo 'hidden' > /tmp/bottom-mpd-status.log
        ;;
    *)
        echo 'error: invalid parameters'
        exit 1
        ;;
esac
