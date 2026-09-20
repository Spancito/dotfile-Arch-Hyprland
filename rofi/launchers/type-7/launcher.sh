#!/usr/bin/env bash
dir="$HOME/.config/rofi/launchers/type-7"
theme='style-3'

rofi \
    -show drun \
    -theme ${dir}/${theme}.rasi
