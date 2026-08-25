THEOS_PACKAGE_SCHEME ?= rootless
TARGET ?= iphone:clang:16.5:16.0
ARCHS = arm64 arm64e
INSTALL_TARGET_PROCESSES = SpringBoard,SpringBoardUIServices

include $(THEOS)/makefiles/common.mk

TWEAK_NAME = TrollPadOS
TrollPadOS_FILES = Tweak.x
TrollPadOS_CFLAGS = -fobjc-arc -Wno-deprecated-declarations
TrollPadOS_FRAMEWORKS = UIKit Foundation AVKit

include $(THEOS_MAKE_PATH)/tweak.mk
