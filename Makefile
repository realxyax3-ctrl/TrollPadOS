THEOS_PACKAGE_SCHEME ?= rootless
TARGET ?= iphone:clang:14.5:14.0
ARCHS = arm64 arm64e
INSTALL_TARGET_PROCESSES = SpringBoard,SpringBoardUIServices

include $(THEOS)/makefiles/common.mk

TWEAK_NAME = TrollPadOS
TrollPadOS_FILES = Tweak.x
TrollPadOS_CFLAGS = -fobjc-arc -Wno-deprecated-declarations
TrollPadOS_FRAMEWORKS = UIKit Foundation AVKit

BUNDLE_NAME = TrollPadOSPrefs
TrollPadOSPrefs_FILES = prefs/TrollPadOSPrefs.m
TrollPadOSPrefs_RESOURCE_DIRS = prefs/Resources
TrollPadOSPrefs_BUNDLE_NAME = TrollPadOS
TrollPadOSPrefs_INSTALL_PATH = /Library/PreferenceBundles
TrollPadOSPrefs_FRAMEWORKS = Foundation UIKit
TrollPadOSPrefs_PRIVATE_FRAMEWORKS = Preferences
TrollPadOSPrefs_CFLAGS = -fobjc-arc

include $(THEOS_MAKE_PATH)/tweak.mk
include $(THEOS_MAKE_PATH)/bundle.mk
