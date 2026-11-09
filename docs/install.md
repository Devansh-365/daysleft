# Install Days Left

Days Left needs macOS 13 Ventura or later. The release is a universal app, so it
runs on Apple Silicon and Intel Macs. Every command below uses tools that ship
with macOS.

## Install a release

### 1. Find the latest release

```bash
curl -fsSL https://api.github.com/repos/Devansh-365/daysleft/releases/latest -o /tmp/daysleft-release.json
TAG=$(plutil -extract tag_name raw /tmp/daysleft-release.json)
URL=$(plutil -extract assets.0.browser_download_url raw /tmp/daysleft-release.json)
DIGEST=$(plutil -extract assets.0.digest raw /tmp/daysleft-release.json)
echo "$TAG $URL $DIGEST"
```

### 2. Download and check it

```bash
curl -fL "$URL" -o "/tmp/DaysLeft-$TAG.dmg"
echo "${DIGEST#sha256:}  /tmp/DaysLeft-$TAG.dmg" | shasum -a 256 -c
```

`shasum` must print `OK`. If it prints `FAILED`, delete the file and stop.

### 3. Install

Quit the running copy first, so the new one can replace it:

```bash
osascript -e 'quit app "Days Left"' 2>/dev/null || true
MNT=$(mktemp -d)
hdiutil attach -nobrowse -quiet -mountpoint "$MNT" "/tmp/DaysLeft-$TAG.dmg"
rm -rf "/Applications/Days Left.app"
ditto "$MNT/Days Left.app" "/Applications/Days Left.app"
hdiutil detach -quiet "$MNT"
open "/Applications/Days Left.app"
```

The app is signed ad-hoc and not notarized by Apple. A DMG downloaded with
`curl` opens without a prompt. One downloaded in a browser may be blocked on
first launch: right-click the app in Applications and choose **Open**, or allow
it in System Settings > Privacy & Security.

### 4. Check it worked

```bash
pgrep -x days-left
plutil -extract CFBundleShortVersionString raw "/Applications/Days Left.app/Contents/Info.plist"
```

The first prints a process ID, the second prints the version without the `v`.
The number of days left in the year shows in the menu bar.

## Launch at login

It is off after installing, and the app never turns it on by itself. To turn it
on, click the number in the menu bar, choose **Preferences…** (⌘,) and switch on
**Launch at login**. If macOS asks for approval, the window shows a button that
opens System Settings > General > Login Items.

## Build from source

Needs Xcode or the Command Line Tools with Swift 5.9 or later.

```bash
git clone https://github.com/Devansh-365/daysleft.git
cd daysleft
./scripts/create-dmg.sh
```

That builds a universal, signed `DaysLeft-v<version>.dmg` in the repo folder.
Install it with step 3, using that DMG's path.

## Uninstall

Turn off **Launch at login** in Preferences first if you turned it on. Then:

```bash
osascript -e 'quit app "Days Left"' 2>/dev/null || true
rm -rf "/Applications/Days Left.app"
defaults delete com.devansh.daysleft 2>/dev/null || true   # removes saved settings
```
