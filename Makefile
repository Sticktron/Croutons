
include $(THEOS)/makefiles/common.mk

TWEAK_NAME = Croutons
Croutons_FILES = Tweak.xm
Croutons_CFLAGS = -fobjc-arc


include $(THEOS_MAKE_PATH)/tweak.mk

after-install::
	install.exec "killall -9 SpringBoard"
SUBPROJECTS += saladbar
include $(THEOS_MAKE_PATH)/aggregate.mk
