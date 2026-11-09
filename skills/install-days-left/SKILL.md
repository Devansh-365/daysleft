---
name: install-days-left
description: Install, upgrade or uninstall Days Left, the macOS menu bar app that shows how many days are left in the year, from the latest GitHub release or from source. Use when the user asks to install, set up, update, reinstall or remove Days Left.
---

# Install Days Left

The exact commands are in
[docs/install.md](https://github.com/Devansh-365/daysleft/blob/main/docs/install.md).
Read that page, then follow these steps. Nothing here needs `sudo`. If a
command asks for a password, stop and give the user the command to run in
Terminal themselves.

1. **Check the Mac.** Days Left needs macOS 13 or later
   (`sw_vers -productVersion`). The release is universal, so Apple Silicon and
   Intel both work.
2. **Find and download the latest release.** Follow steps 1 and 2 of
   "Install a release". Use the release the API returns as latest unless the
   user named a version. The checksum check must print `OK`. If it fails,
   delete the file and tell the user. Do not download a different file to
   get past it.
3. **Install.** Step 3 quits a running copy, replaces
   `/Applications/Days Left.app` and opens the new one. Tell the user before
   you run it that an older copy in Applications will be replaced. If
   `/Applications` is not writable, install to `~/Applications` instead and
   say so.
4. **First launch.** The app is signed ad-hoc and not notarized. If macOS
   blocks it, the user right-clicks the app in Applications and chooses
   **Open**. Never remove the quarantine attribute for them.
5. **Confirm.** Run step 4 of the page: `pgrep -x days-left` prints a process
   ID and the version matches the release tag. Ask the user whether the
   number shows in their menu bar.
6. **Leave launch at login alone.** Never turn it on yourself, with
   `SMAppService`, `osascript` or anything else. Tell the user it is off and
   that they can switch it on in Preferences (⌘, from the dropdown).

An upgrade is the same steps. Settings carry over.

To build from source, follow "Build from source" on the same page, then run
step 3 with the DMG it builds. To remove the app, follow "Uninstall".
