#!/usr/bin/env bash
# Apple-menu power/session actions. Arg: lock|sleep|restart|shutdown|logout.
# Closes the popup first, then runs the action.
sketchybar --set apple popup.drawing=off

case "$1" in
  lock)     osascript -e 'tell application "System Events" to keystroke "q" using {control down, command down}' ;;
  sleep)    pmset sleepnow ;;
  restart)  osascript -e 'tell application "System Events" to restart' ;;
  shutdown) osascript -e 'tell application "System Events" to shut down' ;;
  logout)   osascript -e 'tell application "System Events" to log out' ;;
esac
