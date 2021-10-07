//
// Created by khandker on 10/5/21.
//

#ifndef TRACEROUTE_TRACEROUTELIB_H
#define TRACEROUTE_TRACEROUTELIB_H

#include <jni.h>
#include <android/log.h>

#include <iostream>
#include <vector>
#include <string>
#include <cstring>
#include <cstdio>
#include <future>
#include <thread>
#include <chrono>

extern "C" {
#include <traceroute/traceroute.h>
}

#define TAG "traceroute-native"
#define LOGD(...) __android_log_print(ANDROID_LOG_DEBUG,TAG ,__VA_ARGS__)
#define LOGI(...) __android_log_print(ANDROID_LOG_INFO,TAG ,__VA_ARGS__)
#define LOGW(...) __android_log_print(ANDROID_LOG_WARN,TAG ,__VA_ARGS__)
#define LOGE(...) __android_log_print(ANDROID_LOG_ERROR,TAG ,__VA_ARGS__)
#define LOGF(...) __android_log_print(ANDROID_LOG_FATAL,TAG ,__VA_ARGS__)

using namespace std;

/**
 * @def UNUSED_ARG(arg)
 * @param arg   The argument name.
 * UNUSED_ARG prevents warning about unused argument in a function.
 */
#define UNUSED_ARG(arg)  (void)arg


class TracerouteNative {
public:
    TracerouteNative();

    virtual ~TracerouteNative();

private:
    static TracerouteNative *_instance;

public:
    static TracerouteNative &instance();

    int execute(vector<string> args);

    virtual void onAppendResult(string result) { UNUSED_ARG(result); }

    virtual void onClearResult() {}

private:
    //static int trace(vector<string> args);
};


#endif //TRACEROUTE_TRACEROUTELIB_H
