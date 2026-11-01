#!/usr/bin/env bash
DIRECTION="${1:-next}"

FOCUSED_MONITOR=$(hyprctl monitors -j | jq -r '.[] | select(.focused == true)')
MONITOR_NAME=$(echo "$FOCUSED_MONITOR" | jq -r '.name')
CURRENT_WS=$(echo "$FOCUSED_MONITOR" | jq -r '.activeWorkspace.id')

if [ "$MONITOR_NAME" = "HDMI-A-1" ]; then
    BASE_MIN=1
    BASE_MAX=5
else
    BASE_MIN=6
    BASE_MAX=10
fi

if [ "$DIRECTION" = "next" ]; then
    TARGET_WS=$((CURRENT_WS + 1))
    hyprctl eval "hl.config({ workspace_rule = { workspace = ${TARGET_WS}, monitor = \"${MONITOR_NAME}\" } })" >/dev/null 2>&1
    hyprctl eval "hl.dispatch(hl.dsp.focus({ workspace = ${TARGET_WS} }))" >/dev/null 2>&1
else
    if [ "$CURRENT_WS" -gt "$BASE_MIN" ]; then
        TARGET_WS=$((CURRENT_WS - 1))
        hyprctl eval "hl.dispatch(hl.dsp.focus({ workspace = ${TARGET_WS} }))" >/dev/null 2>&1
    fi
fi
