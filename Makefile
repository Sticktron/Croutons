# Install on MG5S/9
# export THEOS_DEVICE_IP = 192.168.0.105
# export THEOS_DEVICE_PORT = 22

ARCHS = armv7 arm64
TARGET = iphone:clang:10.1:9.0

include $(THEOS)/makefiles/common.mk

TWEAK_NAME = Croutons
Croutons_FILES = Tweak.xm
Croutons_CFLAGS = -fobjc-arc
Croutons_FRAMEWORKS = UIKit

include $(THEOS_MAKE_PATH)/tweak.mk

SUBPROJECTS += Prefs
include $(THEOS_MAKE_PATH)/aggregate.mk

after-install::
	install.exec "killall -9 SpringBoard"
