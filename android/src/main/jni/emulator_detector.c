#include <jni.h>
#include <time.h>
#include <stdbool.h>

JNIEXPORT jboolean JNICALL
Java_com_puzzletak_emu_emulator_1detector_EmulatorDetectorPlugin_checkCpuTiming(
        JNIEnv *env,
        jobject obj) {

    struct timespec start, end;
    long long elapsed;
    int iterations = 1000000;

    clock_gettime(CLOCK_MONOTONIC, &start);

    volatile int dummy = 0;
    for (int i = 0; i < iterations; i++) {
        dummy += i;
    }

    clock_gettime(CLOCK_MONOTONIC, &end);

    elapsed = (end.tv_sec - start.tv_sec) * 1000000000LL +
              (end.tv_nsec - start.tv_nsec);

    return (elapsed < 1000000 || elapsed > 100000000) ? JNI_TRUE : JNI_FALSE;
}
