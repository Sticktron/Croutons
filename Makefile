
#export THEOS_DEVICE_IP=localhost
#export THEOS_DEVICE_PORT=2222
include $(THEOS)/makefiles/common.mk

TWEAK_NAME = Croutons
Croutons_FILES = Tweak.xm
Croutons_FRAMEWORKS = UIKit
Croutons_CFLAGS = -fobjc-arc


include $(THEOS_MAKE_PATH)/tweak.mk

after-install::
	install.exec "killall -9 SpringBoard"
