include $(THEOS)/makefiles/common.mk

BUNDLE_NAME = saladbar
saladbar_INSTALL_PATH = /Library/PreferenceBundles
include $(THEOS_MAKE_PATH)/bundle.mk

internal-stage::
	$(ECHO_NOTHING)mkdir -p $(THEOS_STAGING_DIR)/Library/PreferenceLoader/Preferences$(ECHO_END)
	$(ECHO_NOTHING)cp entry.plist $(THEOS_STAGING_DIR)/Library/PreferenceLoader/Preferences/saladbar.plist$(ECHO_END)
