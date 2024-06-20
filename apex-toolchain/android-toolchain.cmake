# android-toolchain.cmake

# ANDROID_SDK
if(DEFINED ANDROID_SDK)
    set(ANDROID_SDK ${ANDROID_SDK})
elseif(DEFINED ENV{ANDROID_SDK})
    set(ANDROID_SDK $ENV{ANDROID_SDK})
endif()

# ANDROID_NDK
if(DEFINED ANDROID_NDK)
    set(ANDROID_NDK ${ANDROID_NDK})
elseif(DEFINED ENV{ANDROID_NDK})
    set(ANDROID_NDK $ENV{ANDROID_NDK})
endif()

# ANDROID_VER
if(DEFINED ANDROID_VER)
    set(ANDROID_VER ${ANDROID_VER})
elseif(DEFINED ENV{ANDROID_VER})
    set(ANDROID_VER $ENV{ANDROID_VER})
endif()

# ANDROID_ABI
if(DEFINED ANDROID_ABI)
    set(ANDROID_ABI ${ANDROID_ABI})
elseif(DEFINED ENV{ANDROID_ABI})
    set(ANDROID_ABI $ENV{ANDROID_ABI})
endif()

# Prepare Android NDK
set(CMAKE_SYSTEM_NAME Android)
set(CMAKE_ANDROID_NDK_TOOLCHAIN_VERSION clang)
if(DEFINED ANDROID_VER)
    set(CMAKE_SYSTEM_VERSION ${ANDROID_VER})
endif()

# refer to ANDROID_ABI dynamic set CMAKE_SYSTEM_PROCESSOR & CMAKE_ANDROID_ARCH_ABI
if(DEFINED ANDROID_ABI)
    if(${ANDROID_ABI} STREQUAL "arm64-v8a")
        set(CMAKE_SYSTEM_PROCESSOR aarch64)
        set(CMAKE_ANDROID_ARCH_ABI arm64-v8a)
    elseif(${ANDROID_ABI} STREQUAL "armeabi-v7a")
        set(CMAKE_SYSTEM_PROCESSOR armv7)
        set(CMAKE_ANDROID_ARCH_ABI armeabi-v7a)
    elseif(${ANDROID_ABI} STREQUAL "x86")
        set(CMAKE_SYSTEM_PROCESSOR x86)
        set(CMAKE_ANDROID_ARCH_ABI x86)
    elseif(${ANDROID_ABI} STREQUAL "x86_64")
        set(CMAKE_SYSTEM_PROCESSOR x86_64)
        set(CMAKE_ANDROID_ARCH_ABI x86_64)
    endif()
endif()

set(CMAKE_TOOLCHAIN_FILE ${ANDROID_NDK}/build/cmake/android.toolchain.cmake)
set(CMAKE_C_COMPILER ${ANDROID_NDK}/toolchains/llvm/prebuilt/darwin-x86_64/bin/clang)
set(CMAKE_CXX_COMPILER ${ANDROID_NDK}/toolchains/llvm/prebuilt/darwin-x86_64/bin/clang++)