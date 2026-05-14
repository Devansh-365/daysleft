APP_NAME = Days Left
BUNDLE_ID = com.yourname.daysleft
VERSION = 1.0.0
BUILD_DIR = .build

.PHONY: all build test clean release

all: build

build:
	swift build

test:
	swift test

clean:
	rm -rf $(BUILD_DIR)
	swift package clean

release:
	swift build -c release
	@echo "Release $(VERSION) built at $(BUILD_DIR)/release/days-left"

dmg:
	@scripts/create-dmg.sh
