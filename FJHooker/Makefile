GO_EASY_ON_ME = 1
TARGET := iphone:clang:13.1:7.1

ARCHS = arm64

include $(THEOS)/makefiles/common.mk

LIBRARY_NAME = FJHooker

FJHooker_FILES = ../Tweaks/FJPattern.xm  ./FJHImportHooker.c ../Tweaks/SysHooks.xm ../fishhook/fishhook.c FJHooker.mm ../Tweaks/MemHooks.xm ../Tweaks/AeonLucid.xm ../Tweaks/ObjCHooks.xm ../Tweaks/PatchFinder.xm ../Tweaks/LibraryHooks.xm
FJHooker_PUBLIC_HEADERS = FJHooker.h
FJHooker_INSTALL_PATH = /usr/lib
FJHooker_CFLAGS = -fobjc-arc

include $(THEOS_MAKE_PATH)/library.mk
