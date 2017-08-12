ARCHS = armv7 arm64
TARGET = iphone:clang:9.2:9.0

include $(THEOS)/makefiles/common.mk

BUNDLE_NAME = CroutonsPrefs
CroutonsPrefs_CFLAGS = -fobjc-arc
CroutonsPrefs_FILES = CroutonsPrefs.mm
CroutonsPrefs_PRIVATE_FRAMEWORKS = Preferences
CroutonsPrefs_INSTALL_PATH = /Library/PreferenceBundles

include $(THEOS_MAKE_PATH)/bundle.mk

internal-stage::
	$(ECHO_NOTHING)mkdir -p $(THEOS_STAGING_DIR)/Library/PreferenceLoader/Preferences$(ECHO_END)
	$(ECHO_NOTHING)cp entry.plist $(THEOS_STAGING_DIR)/Library/PreferenceLoader/Preferences/CroutonsPrefs.plist$(ECHO_END)
