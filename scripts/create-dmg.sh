#!/bin/bash
set -e

APP_NAME="Days Left"
VOL_NAME="DaysLeft"
BUNDLE_ID="com.devansh.daysleft"
VERSION="1.1.0"
BUILD_DIR=".build/dmg"
APP_BUNDLE="${BUILD_DIR}/${APP_NAME}.app"
UNIVERSAL_BINARY=".build/apple/Products/Release/days-left"
DMG_NAME="DaysLeft-v${VERSION}.dmg"
TMP_DMG="tmp-${DMG_NAME}"
MOUNT_DIR=$(mktemp -d)

echo "Building Days Left v${VERSION} (universal: Apple Silicon + Intel)..."

rm -rf "${BUILD_DIR}"
swift build -c release --arch arm64 --arch x86_64

echo "Creating app bundle..."
mkdir -p "${APP_BUNDLE}/Contents/MacOS"
mkdir -p "${APP_BUNDLE}/Contents/Resources"
cp "${UNIVERSAL_BINARY}" "${APP_BUNDLE}/Contents/MacOS/"

cat > "${APP_BUNDLE}/Contents/Info.plist" <<EOF
<?xml version="1.0" encoding="UTF-8"?>
<!DOCTYPE plist PUBLIC "-//Apple//DTD PLIST 1.0//EN" "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
<plist version="1.0">
<dict>
    <key>CFBundleDevelopmentRegion</key>
    <string>en</string>
    <key>CFBundleExecutable</key>
    <string>days-left</string>
    <key>CFBundleIdentifier</key>
    <string>${BUNDLE_ID}</string>
    <key>CFBundleInfoDictionaryVersion</key>
    <string>6.0</string>
    <key>CFBundleName</key>
    <string>${APP_NAME}</string>
    <key>CFBundlePackageType</key>
    <string>APPL</string>
    <key>CFBundleShortVersionString</key>
    <string>${VERSION}</string>
    <key>CFBundleVersion</key>
    <string>2</string>
    <key>LSMinimumSystemVersion</key>
    <string>13.0</string>
    <key>LSUIElement</key>
    <true/>
</dict>
</plist>
EOF

# Sign the whole bundle (ad-hoc). The linker only signs the bare binary, which leaves
# Info.plist unbound; SMAppService (launch at login) needs a signed .app bundle.
echo "Signing app bundle (ad-hoc)..."
codesign --force --sign - "${APP_BUNDLE}"
codesign --verify --strict "${APP_BUNDLE}"

echo "Creating DMG..."
rm -f "${TMP_DMG}" "${DMG_NAME}"  # hdiutil won't overwrite an existing DMG
hdiutil create -size 20m -fs HFS+ -volname "${VOL_NAME}" -o "${TMP_DMG}" >/dev/null

hdiutil attach "${TMP_DMG}" -mountpoint "${MOUNT_DIR}" >/dev/null
cp -R "${APP_BUNDLE}" "${MOUNT_DIR}/"
ln -s /Applications "${MOUNT_DIR}/Applications"
hdiutil detach "${MOUNT_DIR}" >/dev/null

hdiutil convert "${TMP_DMG}" -format UDZO -o "${DMG_NAME}" >/dev/null

rm -f "${TMP_DMG}"
rm -rf "${APP_BUNDLE}" "${MOUNT_DIR}"

echo ""
echo "Created ${DMG_NAME}"
echo "Upload this to your GitHub release."
