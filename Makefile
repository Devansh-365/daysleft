# Days Left Makefile

APP_NAME = Days Left
BUNDLE_ID = com.yourname.daysleft
VERSION = 1.0.0
BUILD_DIR = build
ARCHIVE_PATH = $(BUILD_DIR)/DaysLeft.xcarchive
EXPORT_PATH = $(BUILD_DIR)/export
DMG_PATH = $(BUILD_DIR)/DaysLeft-$(VERSION).dmg

.PHONY: all build test clean archive notarize dmg release

all: build

build:
	xcodebuild -scheme "Days Left" \
		-configuration Release \
		-destination 'platform=macOS' \
		build

test:
	xcodebuild -scheme "Days Left" \
		-destination 'platform=macOS' \
		test

clean:
	rm -rf $(BUILD_DIR)
	xcodebuild clean

archive:
	xcodebuild -scheme "Days Left" \
		-configuration Release \
		-archivePath $(ARCHIVE_PATH) \
		archive

export: archive
	xcodebuild -exportArchive \
		-archivePath $(ARCHIVE_PATH) \
		-exportPath $(EXPORT_PATH) \
		-exportOptionsPlist resources/export-options.plist

notarize: export
	xcrun notarytool submit $(EXPORT_PATH)/Days\ Left.app \
		--wait \
		--keychain-profile "AC_PASSWORD"

dmg: notarize
	create-dmg \
		--volname "Days Left" \
		--window-pos 200 120 \
		--window-size 600 400 \
		--icon-size 100 \
		--app-drop-link 450 185 \
		"$(DMG_PATH)" \
		"$(EXPORT_PATH)/Days Left.app"

release: dmg
	@echo "Release $(VERSION) ready at $(DMG_PATH)"
	@echo "Next steps:"
	@echo "1. git tag v$(VERSION)"
	@echo "2. git push origin v$(VERSION)"
	@echo "3. Create GitHub Release and attach $(DMG_PATH)"
