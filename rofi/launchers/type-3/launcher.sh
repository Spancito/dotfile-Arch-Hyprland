#!/usr/bin/env bash
dir="$HOME/.config/rofi/launchers/type-3"
theme='style-10'

rofi \
    -show drun \
    -theme ${dir}/${theme}.rasi
