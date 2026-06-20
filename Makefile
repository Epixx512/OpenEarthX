TARGET := iphone:clang:latest:5.0
INSTALL_TARGET_PROCESSES = SpringBoard
ARCHS = armv7 armv7s

include $(THEOS)/makefiles/common.mk

TWEAK_NAME = OpenEarthX

OpenEarthX_FILES = Tweak.x
OpenEarthX_CFLAGS = -fobjc-arc
OpenEarthX_FRAMEWORKS = UIKit

include $(THEOS_MAKE_PATH)/tweak.mk
CFLAGS = -isystem /Applications/Xcode.app/Contents/Developer/Toolchains/XcodeDefault.xctoolchain/usr/lib/clang/6.0/include