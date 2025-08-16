LOCAL_PATH := $(call my-dir)
include $(CLEAR_VARS)
LOCAL_MODULE    := emulator_detector
LOCAL_SRC_FILES := emulator_detector.c
include $(BUILD_SHARED_LIBRARY)