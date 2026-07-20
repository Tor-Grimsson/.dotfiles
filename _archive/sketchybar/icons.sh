#!/usr/bin/env bash
# Nerd Font glyphs, built at runtime from their UTF-8 bytes via printf. Authored this way
# on purpose: literal private-use glyphs get stripped in transit (that's why the icons were
# empty before) — printf reconstructs the exact bytes from plain ASCII source. Font is
# "MesloLGS Nerd Font Mono" (FontAwesome legacy range F0xx–F5xx, present in every NF build).
# Sourced by sketchybarrc and every plugin/item that draws an icon.

# — chrome / menu —
export APPLE=$(printf '\xef\x85\xb9')          # U+F179  apple logo
export GEAR=$(printf '\xef\x80\x93')           # U+F013  gear
export CLOCK=$(printf '\xef\x80\x97')          # U+F017  clock
export CALENDAR=$(printf '\xef\x81\xb3')       # U+F073  calendar

# — power menu rows —
export I_LOCK=$(printf '\xef\x80\xa3')         # U+F023  lock
export I_SLEEP=$(printf '\xef\x86\x86')        # U+F186  moon
export I_LOGOUT=$(printf '\xef\x82\x8b')       # U+F08B  sign-out
export I_RESTART=$(printf '\xef\x80\xa1')      # U+F021  refresh
export I_SHUTDOWN=$(printf '\xef\x80\x91')     # U+F011  power

# — system widgets —
export CPU=$(printf '\xef\x92\xbc')            # U+F4BC  microchip
export MEMORY=$(printf '\xef\x94\xb8')         # U+F538  memory
export VOL_HIGH=$(printf '\xef\x80\xa8')       # U+F028  volume-up
export VOL_LOW=$(printf '\xef\x80\xa7')        # U+F027  volume-down
export VOL_MUTE=$(printf '\xef\x80\xa6')       # U+F026  volume-off
export WIFI_ON=$(printf '\xef\x87\xab')        # U+F1EB  wifi
export WIFI_OFF=$(printf '\xef\x87\xab')       # (fa-wifi dimmed; MDI wifi-off needs NF v3)
export BATT_100=$(printf '\xef\x89\x80')       # U+F240
export BATT_75=$(printf '\xef\x89\x81')        # U+F241
export BATT_50=$(printf '\xef\x89\x82')        # U+F242
export BATT_25=$(printf '\xef\x89\x83')        # U+F243
export BATT_0=$(printf '\xef\x89\x84')         # U+F244
export BATT_CHG=$(printf '\xef\x83\xa7')       # U+F0E7  bolt
export WEATHER=$(printf '\xef\x86\x85')        # U+F185  sun
export BREW=$(printf '\xef\x83\xbc')           # U+F0FC  beer
export TMUX=$(printf '\xef\x84\xa0')           # U+F120  terminal
