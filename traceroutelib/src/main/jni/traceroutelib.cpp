//
// Created by khandker on 10/5/21.
//
#include <cstdio>
#include <utility>

#include "traceroutelib.h"

#define OUTPUT_LENGTH  10240

TracerouteNative *TracerouteNative::_instance = nullptr;

TracerouteNative::TracerouteNative() {
    if(_instance != nullptr){
        throw "Instance already exists";
    }
    _instance = this;
}

TracerouteNative::~TracerouteNative() {
    _instance = nullptr;
}

TracerouteNative &TracerouteNative::instance() {
    if(_instance == nullptr){
        throw "Instance does not exists";
    }
    return *_instance;
}


int printf(const char *fmt, ...) {
    va_list argptr;
    int cnt;
    va_start(argptr, fmt);
    char *buffer = (char *) malloc(OUTPUT_LENGTH);
    memset(buffer, OUTPUT_LENGTH, 0);
    cnt = vsnprintf(buffer, OUTPUT_LENGTH, fmt, argptr);
    buffer[cnt] = '\0';
    TracerouteNative::instance().onAppendResult(buffer);
    free(buffer);
    va_end(argptr);
    return 1;
}

int fprintf(FILE *fp, const char *fmt, ...) {
    va_list argptr;
    int cnt;
    va_start(argptr, fmt);
    char *buffer = (char *) malloc(OUTPUT_LENGTH);
    memset(buffer, OUTPUT_LENGTH, 0);
    cnt = vsnprintf(buffer, OUTPUT_LENGTH, fmt, argptr);
    buffer[cnt] = '\0';
    LOGE("traceroute error message(fprintf): %s", buffer);
    free(buffer);
    va_end(argptr);
    return 1;
}

int vfprintf(FILE *fp, const char *fmt, va_list args) {
    int cnt;
    char *buffer = (char *) malloc(OUTPUT_LENGTH);
    memset(buffer, OUTPUT_LENGTH, 0);
    cnt = vsnprintf(buffer, OUTPUT_LENGTH, fmt, args);
    buffer[cnt] = '\0';
    LOGE("traceroute error message(vfprintf): %s", buffer);
    free(buffer);
    return 1;
}

void perror(const char *msg) {
    LOGE("traceroute error message(perror): %s", msg);
}

/*void exit(int status) {
    // avoid some device crash. eg: vivo x7
    (*g_jvm)->DetachCurrentThread(g_jvm);
    exec_status = -3;
    LOGE("traceroute error to exit program, status:%d", status);
    pthread_exit(0);
}*/

template<typename T>
bool future_is_ready(std::future<T>& t){
    return t.wait_for(std::chrono::seconds(0)) == std::future_status::ready;
}

int trace(vector<string> args){
    int exec_status = -3;
    int size = args.size();
    LOGD("agrs size: %d", size);
    char *argv[size];
    for(int i=0;i<size;i++){
        argv[i] = new char[args[i].length()];
        strcpy(argv[i], args[i].c_str());
        LOGD("agrs: %s", argv[i]);
    }
    TracerouteNative::instance().onClearResult();
    exec_status = exec_trace(size, argv);
    LOGD("execute command result: %d", exec_status);
    for(auto &a: argv){
        delete a;
    }
    return exec_status;
}

int TracerouteNative::execute(vector<string> args) {
    auto trace_future = std::async(std::launch::async, trace, args);
    auto result = trace_future.get();
    LOGD("finish traceroute, status: %d", result);
    return result;
}
