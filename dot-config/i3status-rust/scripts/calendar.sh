#! /bin/bash

send_notification() {
    TODAY=$(date '+%-d')
    HEAD=$(cal -m "$1" | head -n1)
    BODY=$(cal -m "$1" | tail -n7 | sed -z "s|$TODAY|<u><b>$TODAY</b></u>|1")
    dunstify \
        --appname "calendar 󰸗" \
        --hints string:x-canonical-private-synchronous:calendar \
        --urgency low \
        "$HEAD" "$BODY"
}

handle_action() {
    echo "$DIFF" >"$TMP"
    if [ "$DIFF" -ge 0 ]; then
        send_notification "+$DIFF months"
    else
        send_notification "$((-DIFF)) months ago"
    fi
}

TMP=${XDG_RUNTIME_DIR:-/tmp}/"$UID"_calendar_notification_month
touch "$TMP"

DIFF=$(<"$TMP")

case $1 in
"curr") DIFF=0 ;;
"next") DIFF=$((DIFF + 1)) ;;
"prev") DIFF=$((DIFF - 1)) ;;
esac

handle_action
