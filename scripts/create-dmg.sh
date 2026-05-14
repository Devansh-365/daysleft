#!/bin/bash
set -e

APP_NAME="Days Left"
VOL_NAME="DaysLeft"
BUNDLE_ID="com.devansh.daysleft"
VERSION="1.0.0"
BUILD_DIR=".build/release"
APP_BUNDLE="${BUILD_DIR}/${APP_NAME}.app"
DMG_NAME="DaysLeft-v${VERSION}.dmg"
TMP_DMG="tmp-${DMG_NAME}"
MOUNT_DIR=$(mktemp -d)

echo "Building Days Left v${VERSION}..."

rm -rf "${BUILD_DIR}"
swift build -c release

echo "Creating app bundle..."
mkdir -p "${APP_BUNDLE}/Contents/MacOS"
mkdir -p "${APP_BUNDLE}/Contents/Resources"
cp "${BUILD_DIR}/days-left" "${APP_BUNDLE}/Contents/MacOS/"

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
    <string>1</string>
    <key>LSMinimumSystemVersion</key>
    <string>13.0</string>
    <key>LSUIElement</key>
    <true/>
</dict>
</plist>
EOF

echo "Creating DMG..."
rm -f "${TMP_DMG}"
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
