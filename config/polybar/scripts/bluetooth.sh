#!/usr/bin/env sh

bluetooth_print() {
    bluetoothctl | while read -r; do
        if [ "$(systemctl is-active "bluetooth.service")" = "active" ]; then
            printf ''

            devices_paired=$(bluetoothctl devices Paired | grep Device | cut -d ' ' -f 2)
            counter=0

            for device in $devices_paired; do
                device_info=$(bluetoothctl info "$device")

                if echo "$device_info" | grep -q "Connected: yes"; then
                    device_alias=$(echo "$device_info" | grep "Alias" | cut -d ' ' -f 2-)

                    if [ $counter -gt 0 ]; then
                        printf ", %s" "$device_alias"
                    else
                        printf " %s" "$device_alias"
                    fi

                    counter=$((counter + 1))
                fi
            done

            if [ $counter -eq 0 ]; then
                printf " No devices"
            fi

            printf '\n'
        else
            echo " Service Inactive"
        fi
    done
}

bluetooth_toggle() {
    if bluetoothctl show | grep -q "Powered: no"; then
        bluetoothctl power on >> /dev/null
        sleep 1

        devices_paired=$(bluetoothctl paired-devices | grep Device | cut -d ' ' -f 2)
        echo "$devices_paired" | while read -r line; do
            bluetoothctl connect "$line" >> /dev/null
        done
    else
        devices_paired=$(bluetoothctl paired-devices | grep Device | cut -d ' ' -f 2)
        echo "$devices_paired" | while read -r line; do
            bluetoothctl disconnect "$line" >> /dev/null
        done

        bluetoothctl power off >> /dev/null
    fi
}

case "$1" in
    --open-tui)
        if command -v alacritty > /dev/null; then
            alacritty -o window.padding.x=40 window.padding.y=40 \
                      -e bluetoothctl &
        else
            xterm -e bluetoothctl &
        fi
        ;;
    --toggle)
        bluetooth_toggle
        ;;
    *)
        bluetooth_print
        ;;
esac
