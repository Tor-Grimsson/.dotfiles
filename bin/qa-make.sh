#!/bin/bash
# qa-make.sh — stamp out a new Finder Quick Action (.workflow) that runs a shell
# command on the selected files. The bundle is generated into the repo
# (macos/services/) and symlinked into ~/Library/Services — exactly how the
# hand-made ones (Open in glow, Select Every Other, …) live. bootstrap.sh
# re-links every *.workflow in macos/services/, so new ones survive a fresh machine.

usage() {
  cat <<'EOF'
qa-make.sh — generate a Finder Quick Action that runs a shell command.

Creates <Name>.workflow in ~/.dotfiles/macos/services/ (tracked) and symlinks
it into ~/Library/Services. The action shows up in Finder's right-click →
Quick Actions / Services menu immediately. Selected files arrive as "$@"
in a /bin/bash Run-Shell-Script step.

USAGE
  qa-make.sh [options] "<Name>" '<command>'

ARGUMENTS
  Name      Menu label, e.g. "Shoot to _trash". Also the .workflow name.
  command   Shell snippet; selected files/folders are "$@".
            Single-quote it so $HOME/"$@" survive until run time.

OPTIONS
  -t, --types <uti,...>  Accepted file types (default: public.item = any
                         file or folder). E.g. public.image, public.plain-text.
  -f, --force            Overwrite an existing workflow of the same name.
  -h, --help             Show this.

EXAMPLES
  # fake-trash: shoot selection into a _trash folder NEXT TO each file
  qa-make.sh "Shoot to _trash" 'for f in "$@"; do "$HOME/bin/fs-shoot.sh" "$(dirname "$f")/_trash" "$f"; done'

  # fixed destination: collect into one global staging folder
  qa-make.sh "Shoot to Staging" '"$HOME/bin/fs-shoot.sh" "$HOME/_staging" "$@"'

  # images only, run through the web-export pipeline
  qa-make.sh -t public.image "Web export" '"$HOME/bin/img-web.sh" "$@"'

NOTES
  - Hotkey (optional): System Settings → Keyboard → Keyboard Shortcuts →
    Services → General. To make it bootstrap-able, add a `defaults write pbs
    NSServicesStatus` line to macos/defaults.sh §Services — qa-make prints
    the exact line on creation.
  - Remove an action: delete the bundle from macos/services/ and the symlink
    from ~/Library/Services.
EOF
}

REPO="$HOME/.dotfiles"
SERVICES_DIR="$REPO/macos/services"
TYPES="public.item"
FORCE=false

while [[ "$#" -gt 0 ]]; do
    case $1 in
        -t|--types) TYPES="$2"; shift 2 ;;
        -f|--force) FORCE=true; shift ;;
        -h|--help) usage; exit 0 ;;
        -*) echo "Unknown parameter: $1" >&2; echo "Try: $0 --help" >&2; exit 1 ;;
        *) break ;;
    esac
done

[[ "$#" -eq 2 ]] || { usage >&2; exit 1; }
NAME="$1"
CMD="$2"

WF="$SERVICES_DIR/$NAME.workflow"
if [ -e "$WF" ] && [ "$FORCE" != true ]; then
    echo "Already exists: $WF  (use --force to overwrite)" >&2
    exit 1
fi

# plist payloads are XML — escape the user's command and name
xml_escape() { sed -e 's/&/\&amp;/g' -e 's/</\&lt;/g' -e 's/>/\&gt;/g' <<<"$1"; }
NAME_X="$(xml_escape "$NAME")"
CMD_X="$(xml_escape "$CMD")"

# NSSendFileTypes entries from the comma-separated --types list
TYPES_X=""
IFS=',' read -ra UTI <<<"$TYPES"
for t in "${UTI[@]}"; do
    TYPES_X+="				<string>$(xml_escape "$t")</string>"$'\n'
done

UUID_IN="$(uuidgen)"; UUID_OUT="$(uuidgen)"; UUID_ACTION="$(uuidgen)"

mkdir -p "$WF/Contents"

# ── Info.plist — service registration: Finder context + accepted types ───────
cat >"$WF/Contents/Info.plist" <<PLIST
<?xml version="1.0" encoding="UTF-8"?>
<!DOCTYPE plist PUBLIC "-//Apple//DTD PLIST 1.0//EN" "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
<plist version="1.0">
<dict>
	<key>NSServices</key>
	<array>
		<dict>
			<key>NSMenuItem</key>
			<dict>
				<key>default</key>
				<string>${NAME_X}</string>
			</dict>
			<key>NSMessage</key>
			<string>runWorkflowAsService</string>
			<key>NSRequiredContext</key>
			<dict>
				<key>NSApplicationIdentifier</key>
				<string>com.apple.finder</string>
			</dict>
			<key>NSSendFileTypes</key>
			<array>
${TYPES_X}			</array>
		</dict>
	</array>
</dict>
</plist>
PLIST

# ── document.wflow — one Run-Shell-Script action, input as arguments ("$@") ──
cat >"$WF/Contents/document.wflow" <<PLIST
<?xml version="1.0" encoding="UTF-8"?>
<!DOCTYPE plist PUBLIC "-//Apple//DTD PLIST 1.0//EN" "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
<plist version="1.0">
<dict>
	<key>AMApplicationBuild</key>
	<string>523</string>
	<key>AMApplicationVersion</key>
	<string>2.10</string>
	<key>AMDocumentVersion</key>
	<string>2</string>
	<key>actions</key>
	<array>
		<dict>
			<key>action</key>
			<dict>
				<key>AMAccepts</key>
				<dict>
					<key>Container</key>
					<string>List</string>
					<key>Optional</key>
					<true/>
					<key>Types</key>
					<array>
						<string>com.apple.cocoa.string</string>
					</array>
				</dict>
				<key>AMActionVersion</key>
				<string>2.0.3</string>
				<key>AMApplication</key>
				<array>
					<string>Automator</string>
				</array>
				<key>AMParameterProperties</key>
				<dict>
					<key>COMMAND_STRING</key>
					<dict/>
					<key>CheckedForUserDefaultShell</key>
					<dict/>
					<key>inputMethod</key>
					<dict/>
					<key>shell</key>
					<dict/>
					<key>source</key>
					<dict/>
				</dict>
				<key>AMProvides</key>
				<dict>
					<key>Container</key>
					<string>List</string>
					<key>Types</key>
					<array>
						<string>com.apple.cocoa.string</string>
					</array>
				</dict>
				<key>ActionBundlePath</key>
				<string>/System/Library/Automator/Run Shell Script.action</string>
				<key>ActionName</key>
				<string>Run Shell Script</string>
				<key>ActionParameters</key>
				<dict>
					<key>COMMAND_STRING</key>
					<string>${CMD_X}</string>
					<key>CheckedForUserDefaultShell</key>
					<true/>
					<key>inputMethod</key>
					<integer>1</integer>
					<key>shell</key>
					<string>/bin/bash</string>
					<key>source</key>
					<string></string>
				</dict>
				<key>BundleIdentifier</key>
				<string>com.apple.Automator.RunShellScript</string>
				<key>CFBundleVersion</key>
				<string>2.0.3</string>
				<key>CanShowSelectedItemsWhenRun</key>
				<false/>
				<key>CanShowWhenRun</key>
				<true/>
				<key>Category</key>
				<array>
					<string>AMCategoryUtilities</string>
				</array>
				<key>Class Name</key>
				<string>RunShellScriptAction</string>
				<key>InputUUID</key>
				<string>${UUID_IN}</string>
				<key>Keywords</key>
				<array>
					<string>Shell</string>
					<string>Script</string>
					<string>Command</string>
					<string>Run</string>
					<string>Unix</string>
				</array>
				<key>OutputUUID</key>
				<string>${UUID_OUT}</string>
				<key>UUID</key>
				<string>${UUID_ACTION}</string>
				<key>UnlocalizedApplications</key>
				<array>
					<string>Automator</string>
				</array>
				<key>arguments</key>
				<dict>
					<key>0</key>
					<dict>
						<key>default value</key>
						<integer>0</integer>
						<key>name</key>
						<string>inputMethod</string>
						<key>required</key>
						<string>0</string>
						<key>type</key>
						<string>0</string>
						<key>uuid</key>
						<string>0</string>
					</dict>
					<key>1</key>
					<dict>
						<key>default value</key>
						<false/>
						<key>name</key>
						<string>CheckedForUserDefaultShell</string>
						<key>required</key>
						<string>0</string>
						<key>type</key>
						<string>0</string>
						<key>uuid</key>
						<string>1</string>
					</dict>
					<key>2</key>
					<dict>
						<key>default value</key>
						<string></string>
						<key>name</key>
						<string>source</string>
						<key>required</key>
						<string>0</string>
						<key>type</key>
						<string>0</string>
						<key>uuid</key>
						<string>2</string>
					</dict>
					<key>3</key>
					<dict>
						<key>default value</key>
						<string></string>
						<key>name</key>
						<string>COMMAND_STRING</string>
						<key>required</key>
						<string>0</string>
						<key>type</key>
						<string>0</string>
						<key>uuid</key>
						<string>3</string>
					</dict>
					<key>4</key>
					<dict>
						<key>default value</key>
						<string>/bin/sh</string>
						<key>name</key>
						<string>shell</string>
						<key>required</key>
						<string>0</string>
						<key>type</key>
						<string>0</string>
						<key>uuid</key>
						<string>4</string>
					</dict>
				</dict>
				<key>isViewVisible</key>
				<integer>1</integer>
				<key>location</key>
				<string>309.000000:253.000000</string>
				<key>nibPath</key>
				<string>/System/Library/Automator/Run Shell Script.action/Contents/Resources/Base.lproj/main.nib</string>
			</dict>
			<key>isViewVisible</key>
			<integer>1</integer>
		</dict>
	</array>
	<key>connectors</key>
	<dict/>
	<key>workflowMetaData</key>
	<dict>
		<key>applicationBundleIDsByPath</key>
		<dict/>
		<key>applicationPaths</key>
		<array/>
		<key>presentationMode</key>
		<integer>11</integer>
		<key>processesInput</key>
		<integer>0</integer>
		<key>serviceApplicationBundleID</key>
		<string>com.apple.finder</string>
		<key>serviceApplicationPath</key>
		<string>/System/Library/CoreServices/Finder.app</string>
		<key>serviceInputTypeIdentifier</key>
		<string>com.apple.Automator.fileSystemObject</string>
		<key>serviceOutputTypeIdentifier</key>
		<string>com.apple.Automator.nothing</string>
		<key>serviceProcessesInput</key>
		<integer>0</integer>
		<key>systemImageName</key>
		<string>NSActionTemplate</string>
		<key>useAutomaticInputType</key>
		<integer>0</integer>
		<key>workflowTypeIdentifier</key>
		<string>com.apple.Automator.servicesMenu</string>
	</dict>
</dict>
</plist>
PLIST

# sanity-check both plists before going live
plutil -lint -s "$WF/Contents/Info.plist" "$WF/Contents/document.wflow" || {
    echo "Generated plist failed lint — removing $WF" >&2
    rm -rf "$WF"
    exit 1
}

# link into ~/Library/Services + refresh the Services registry
mkdir -p "$HOME/Library/Services"
ln -sfn "$WF" "$HOME/Library/Services/$NAME.workflow"
/System/Library/CoreServices/pbs -flush 2>/dev/null || true

cat <<DONE
Created:  $WF
Linked:   ~/Library/Services/$NAME.workflow
Shows up under Finder right-click → Quick Actions / Services.

Optional hotkey — System Settings → Keyboard → Keyboard Shortcuts → Services,
or add to macos/defaults.sh §Services (bootstrap-able):

  defaults write pbs NSServicesStatus -dict-add '"(null) - $NAME - runWorkflowAsService"' \\
    '{key_equivalent = "\$~^x"; enabled_services_menu = 1; presentation_modes = {ContextMenu = 1; ServicesMenu = 1;};}'   # x = your key

DONE
