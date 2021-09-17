#!/usr/bin/env bash

UNIT="redshift.service"

redshift_print() {
    if [[ "$(systemctl --user is-active "$UNIT")" == "active" ]]; then

        TEMPS=()
        while IFS='' read -r line; do
            TEMPS+=("$line")
        done < <(systemctl --user status redshift | grep 'Color temperature' | sed 's/.*: //')

        if [[ ${#TEMPS[@]} -gt 0 ]]; then
            printf " %s" "${TEMPS[-1]}"
        else
            printf " Loading..."
        fi

        printf '\n'
    else
        echo " Turned Off"
    fi
}

redshift_toggle() {
    if [[ "$(systemctl --user is-active "$UNIT")" == "active" ]]; then
        if command -v notify-send > /dev/null; then
            notify-send 'Redshift stopped' 'Redshift service is stopping...'
        fi
        systemctl --user stop redshift
    else
        if command -v notify-send > /dev/null; then
            notify-send 'Redshift started' 'Redshift service is starting...'
        fi
        systemctl --user start redshift
    fi
}

case "$1" in
    --toggle)
        redshift_toggle
        ;;
    *)
        redshift_print
        ;;
esac
