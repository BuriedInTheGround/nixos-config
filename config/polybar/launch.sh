#!/usr/bin/env bash

# Terminate already running bar instances.
polybar-msg cmd quit

# Export the temperature sysfs path.
export HWMON="/sys/devices/platform/coretemp.0/hwmon/$(ls /sys/devices/platform/coretemp.0/hwmon/)/temp1_input"

# Determine the system type.
BATTERIES=( $(ls -1 /sys/class/power_supply) )
if [[ ${#BATTERIES[@]} -ge 2 ]]; then
    SYS_TYPE="laptop"
else
    SYS_TYPE="desktop"
fi

if [[ $SYS_TYPE == "desktop" ]]; then
    export MONITOR_MAIN=$(xrandr -q | grep 'primary' | cut -d ' ' -f 1)

    # Launch `top-main` bar.
    echo "--- $(date) ---" | tee -a /tmp/polybar-top-main.log
    polybar top-main 2>&1 | tee -a /tmp/polybar-top-main.log & disown

    MONITORS=( $(xrandr -q | grep ' connected' | cut -d ' ' -f 1) )

    # If a second monitor is present, launch `top-secondary` bar.
    if [[ ${#MONITORS[@]} -eq 2 ]]; then
        temp=( "${MONITORS[@]/$MONITOR_MAIN}" )
        export MONITOR_SECONDARY=${temp[1]}

        echo "--- $(date) ---" | tee -a /tmp/polybar-top-secondary.log
        polybar top-secondary 2>&1 | tee -a /tmp/polybar-top-secondary.log & disown
    fi

    # Launch `bottom-mpd` bar.
    echo "--- $(date) ---" | tee -a /tmp/polybar-bottom-mpd.log
    polybar bottom-mpd 2>&1 | tee -a /tmp/polybar-bottom-mpd.log & disown
elif [[ $SYS_TYPE == "laptop" ]]; then
    echo "---" | tee -a /tmp/polybar-generic.log
    echo "Error: laptop setup not implemented." | tee -a /tmp/polybar-generic.log
else
    echo "---" | tee -a /tmp/polybar-top-main.log
    echo "Error: cannot determine system type." | tee -a /tmp/polybar-generic.log
fi

# Reset `bottom-mpd` bar visibility, then wait, then save the bar PID, than
# wait more and finally hide the bar.
echo 'visible' > /tmp/bottom-mpd-status.log
sleep 2
polybar-msg action "#mpd-ipc.hook.0" & disown
sleep 1
~/.config/polybar/scripts/toggle.sh & disown

echo "Bars launched..."
