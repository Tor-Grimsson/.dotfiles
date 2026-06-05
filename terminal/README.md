# Terminal.app prefs

`com.apple.Terminal.plist` is the full Terminal.app preferences domain (profiles, default
profile, window/font/color settings). Default profile here: **tog**.

Unlike iTerm (which loads from a custom folder), Terminal is backed by `cfprefsd` and caches
its prefs — a symlink into `~/Library/Preferences` gets clobbered. So this is **import/export**,
not a symlink. Repo is the source of truth; changes are one-directional until re-exported.

## Restore on a new machine
`bootstrap.sh` does this automatically. Manually (with **Terminal closed**):
```sh
defaults import com.apple.Terminal ~/.dotfiles/terminal/com.apple.Terminal.plist
killall cfprefsd
```

## After tweaking Terminal — re-capture
```sh
defaults export com.apple.Terminal ~/.dotfiles/terminal/com.apple.Terminal.plist
```
Then commit. Forgetting this means your live tweaks aren't backed up.
