#!/usr/bin/env bash
# finder-select-alternate.sh [odd|even|invert] — reshape the front Finder window's selection.
# Engine for the "Select Every Other" / "…(Even)" Finder Quick Actions (macos/services/).

usage() {
  cat <<'EOF'
finder-select-alternate.sh — reshape the front Finder window's selection.

MODES (positional, default = odd)
  odd      keep every other item — 1st, 3rd, 5th… of the current selection   (Quick Action ⇧⌥⌃A)
  even     keep the other half   — 2nd, 4th, 6th…                            (Quick Action ⇧⌥⌃S)
  invert   select everything in the window that is NOT currently selected

USAGE
  finder-select-alternate.sh [odd|even|invert]

EXAMPLES
  finder-select-alternate.sh            # odd (every other)
  finder-select-alternate.sh even       # the complementary half
  finder-select-alternate.sh invert     # select all NOT currently selected

NOTES
  odd/even act on the CURRENT selection (or the whole window if fewer than 2 are
  selected). AppleScript reads items in Finder's internal order, NOT the window's
  visual sort — for a predictable checkerboard, sort by Name first.
EOF
}

# Only -h/--help is intercepted; any other first arg is the mode (defaults to odd).
case "${1:-}" in
  -h|--help) usage; exit 0 ;;
esac

mode="${1:-odd}"
osascript - "$mode" >/dev/null <<'APPLE'
on run argv
    set mode to item 1 of argv
    tell application "Finder"
        if not (exists front window) then return
        set picks to {}
        if mode is "invert" then
            set sel to selection
            repeat with anItem in (items of (target of front window))
                if sel does not contain (contents of anItem) then set end of picks to contents of anItem
            end repeat
        else
            set sel to selection
            if (count sel) < 2 then set sel to items of (target of front window)
            set keepOdd to (mode is not "even")
            repeat with i from 1 to count sel
                if ((i mod 2 = 1) = keepOdd) then set end of picks to item i of sel
            end repeat
        end if
        if picks is not {} then select picks
    end tell
end run
APPLE
