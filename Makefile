# Install on MG5S-9
# export THEOS_DEVICE_IP = 192.168.0.105
# export THEOS_DEVICE_PORT = 22

ARCHS = armv7 arm64
TARGET = iphone:clang:10.1:9.0

include $(THEOS)/makefiles/common.mk

# TWEAK_NAME = CroutonsUI CroutonsSB
TWEAK_NAME = CroutonsUI

CroutonsUI_FILES = CroutonsUI.xm
CroutonsUI_CFLAGS = -fobjc-arc
CroutonsUI_PRIVATE_FRAMEWORKS = AppSupport
CroutonsUI_LIBRARIES = rocketbootstrap

# CroutonsSB_FILES = CroutonsSB.xm
# CroutonsSB_CFLAGS = -fobjc-arc
# CroutonsSB_PRIVATE_FRAMEWORKS = AppSupport
# CroutonsSB_LIBRARIES = rocketbootstrap

include $(THEOS_MAKE_PATH)/tweak.mk

SUBPROJECTS += Prefs
include $(THEOS_MAKE_PATH)/aggregate.mk

after-install::
	install.exec "killall -9 SpringBoard"
