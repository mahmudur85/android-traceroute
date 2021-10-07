LOCAL_PATH := $(call my-dir)

include $(CLEAR_VARS)

LIBRARY_PATH := $(LOCAL_PATH)/traceroute-2.1.0

LOCAL_LDLIBS :=-llog -ldl

APP_OPTIM := debug

LIBRARY_C_LIST := $(wildcard $(LIBRARY_PATH)/libsupp/*.c)
LIBRARY_C_LIST += $(wildcard $(LIBRARY_PATH)/traceroute/*.c)

LOCAL_MODULE    := traceroute
LOCAL_C_INCLUDES:= $(LIBRARY_PATH)
LOCAL_SRC_FILES := $(LIBRARY_C_LIST:$(LOCAL_PATH)/%=%) traceroutelib-wrap.cpp  traceroutelib.cpp
LOCAL_CPP_EXTENSION := .cxx .cpp .cc

# LOCAL_CFLAGS += -DHAVE_FCNTL_H \
#                -DHAVE_SYS_TIME_H \
#                -DHAVE_STRUCT_TIMEVAL \
#                -DHAVE_SYS_SELECT_H \
#                -DHAVE_PTHREAD \
#                -DHAVE_SEMAPHORE_H \
#                -DENABLE_TRACE \
#                -DOSIP_MT

LOCAL_CPPFLAGS 	:= -fexceptions  -frtti
LOCAL_CFLAGS += -fPIE -fPIC
LOCAL_LDFLAGS += -fPIE  -pie

include $(BUILD_SHARED_LIBRARY)
