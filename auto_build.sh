#!/bin/bash

# Default configuration
DEFAULT_BUILD_TYPE=debug
DEFAULT_CMAKE="cmake"
DEFAULT_NINJA="ninja"
DEFAULT_JOBS=4
DEFAULT_ANDROID_VER=21          # env used
DEFAULT_CONFIRM_OPTION="-n"     # Default confirmation option

# Function: Show help message
show_help() {
    echo "Usage: $0 [options]"
    echo "Options:"
    echo "  --platform PLATFORM      Target platform (e.g., android, linux, macos, windows)"
    echo "  --arch-abi ARCH          Target ABI (e.g., x86_64, aarch64, arm64, x86, arm64-v8a, armeabi-v7a)"
    echo "  --build-type TYPE        Build type (Debug, Release, etc.)"
    echo "  --cmake PATH             Path to CMake executable"
    echo "  --ninja PATH             Path to Ninja executable"
    echo "  --jobs N                 Number of parallel jobs"
    echo "  --options OPTIONS        Extra CMake options, see README.md"
#    echo "  --android-sdk PATH       [android] Path to Android SDK"
    echo "  --android-ndk PATH       [android] Path to Android NDK"
    echo "  --android-ver N          [android] Android system version (default: 21)"
    echo "  -y/n/c                   Setting 'yes/no/cancel' to auto prepare sd-models"
    echo "  -h, --help               Show this help message"
}

# Parse command line arguments
CONFIRM_OPTION=""
while [[ "$#" -gt 0 ]]; do
    case $1 in
        --platform) PLATFORM="$2"; shift ;;
        --arch-abi) TARGET_ABI="$2"; shift ;;
        --build-type) BUILD_TYPE="$2"; shift ;;
        --cmake) CMAKE="$2"; shift ;;
        --ninja) NINJA="$2"; shift ;;
        --jobs) JOBS="$2"; shift ;;
        --options) CMAKE_OPTIONS="$2"; shift ;;
#        --android-sdk) ANDROID_SDK="$2"; shift ;;
        --android-ndk) ANDROID_NDK="$2"; shift ;;
        --android-ver) ANDROID_VER="$2"; shift ;;
        -n) CONFIRM_OPTION="-n" ;;
        -y) CONFIRM_OPTION="-y" ;;
        -c) CONFIRM_OPTION="-c" ;;
        -h|--help) show_help; exit 0 ;;
        *) echo "Unknown parameter passed: $1"; show_help; exit 1 ;;
    esac
    shift
done

# Set default values
BUILD_TYPE=${BUILD_TYPE:-$DEFAULT_BUILD_TYPE}
JOBS=${JOBS:-$DEFAULT_JOBS}
CMAKE=${CMAKE:-$DEFAULT_CMAKE}
NINJA=${NINJA:-$DEFAULT_NINJA}
ANDROID_VER=${ANDROID_VER:-$DEFAULT_ANDROID_VER}
CMAKE_OPTIONS=${CMAKE_OPTIONS:-}
CONFIRM_OPTION=${CONFIRM_OPTION:-$DEFAULT_CONFIRM_OPTION}

# Detect platform if not specified
if [ -z "$PLATFORM" ]; then
    case "$(uname -s)" in
        Linux*)     PLATFORM=linux ;;
        Darwin*)    PLATFORM=macos ;;
        CYGWIN*|MINGW*|MSYS*) PLATFORM=windows ;;
        Android*)   PLATFORM=android ;;
        *)          PLATFORM=unknown ;;
    esac
fi

# Detect TARGET_ABI if not specified or set to default
if [ -z "$TARGET_ABI" ] || [ "$TARGET_ABI" == "default" ]; then
    case "$(uname -m)" in
        x86_64)
            TARGET_ABI="x86_64"
            ;;
        aarch64 | arm64)
            TARGET_ABI="aarch64"
            ;;
        i386 | i686)
            TARGET_ABI="x86"
            ;;
        armv7l)
            TARGET_ABI="armeabi-v7a"
            ;;
        *)
            echo "Unsupported current system architecture: $(uname -m)"
            exit 1
            ;;
    esac
fi

# Set project root and build directories
PROJECT_ROOT=$(dirname "$0")
BUILD_DIR=${PROJECT_ROOT}/cmake-build-${BUILD_TYPE}-${PLATFORM}-${TARGET_ABI}

# Clean old build directory
rm -rf ${BUILD_DIR}
mkdir -p ${BUILD_DIR}

# Map platform to CMAKE_SYSTEM_NAME
case "$PLATFORM" in
    android)
        CMAKE_SYSTEM_NAME="Android"
        ;;
    linux)
        CMAKE_SYSTEM_NAME="Linux"
        ;;
    macos)
        CMAKE_SYSTEM_NAME="Darwin"
        ;;
    windows)
        CMAKE_SYSTEM_NAME="Windows"
        ;;
    *)
        echo "Unsupported platform: $PLATFORM"
        exit 1
        ;;
esac

# Map arch-abi to CMAKE_SYSTEM_PROCESSOR
case "$TARGET_ABI" in
    x86_64)
        CMAKE_SYSTEM_PROCESSOR="x86_64"
        ;;
    aarch64)
        CMAKE_SYSTEM_PROCESSOR="aarch64"
        ;;
    arm64)
        CMAKE_SYSTEM_PROCESSOR="arm64"
        ;;
    x86)
        CMAKE_SYSTEM_PROCESSOR="x86"
        ;;
    arm64-v8a)
        CMAKE_SYSTEM_PROCESSOR="arm64-v8a"
        ;;
    armeabi-v7a)
        CMAKE_SYSTEM_PROCESSOR="armeabi-v7a"
        ;;
    *)
        echo "Unsupported arch-abi: $TARGET_ABI"
        echo "Please choose arch-abi from [x86_64, aarch64, arm64, x86, arm64-v8a, armeabi-v7a]"
        exit 1
        ;;
esac

# Platform-specific configuration
case "$PLATFORM" in
    android)
#        CMAKE_OPTIONS="${CMAKE_OPTIONS} -DANDROID_SDK=${ANDROID_SDK}"
        CMAKE_OPTIONS="${CMAKE_OPTIONS} -DANDROID_NDK=${ANDROID_NDK}"
        CMAKE_OPTIONS="${CMAKE_OPTIONS} -DCMAKE_SYSTEM_NAME=${CMAKE_SYSTEM_NAME}"
        CMAKE_OPTIONS="${CMAKE_OPTIONS} -DCMAKE_SYSTEM_PROCESSOR=${CMAKE_SYSTEM_PROCESSOR}"
        CMAKE_OPTIONS="${CMAKE_OPTIONS} -DCMAKE_SYSTEM_VERSION=${ANDROID_VER}"
        ;;

    linux)
        CMAKE_OPTIONS="${CMAKE_OPTIONS}"
        CMAKE_OPTIONS="${CMAKE_OPTIONS} -DCMAKE_SYSTEM_NAME=${CMAKE_SYSTEM_NAME}"
        CMAKE_OPTIONS="${CMAKE_OPTIONS} -DCMAKE_SYSTEM_PROCESSOR=${CMAKE_SYSTEM_PROCESSOR}"
        ;;

    macos)
        CMAKE_OPTIONS="${CMAKE_OPTIONS}"
        CMAKE_OPTIONS="${CMAKE_OPTIONS} -DCMAKE_SYSTEM_NAME=${CMAKE_SYSTEM_NAME}"
        CMAKE_OPTIONS="${CMAKE_OPTIONS} -DCMAKE_SYSTEM_PROCESSOR=${CMAKE_SYSTEM_PROCESSOR}"
        ;;

    windows)
        CMAKE_OPTIONS="${CMAKE_OPTIONS}"
        CMAKE_OPTIONS="${CMAKE_OPTIONS} -DCMAKE_SYSTEM_NAME=${CMAKE_SYSTEM_NAME}"
        CMAKE_OPTIONS="${CMAKE_OPTIONS} -DCMAKE_SYSTEM_PROCESSOR=${CMAKE_SYSTEM_PROCESSOR}"
        ;;

    *)
        echo "Unknown platform: $PLATFORM"
        exit 1
        ;;
esac

# Run CMake configuration
${CMAKE} \
    -DCMAKE_BUILD_TYPE=${BUILD_TYPE} \
    ${CMAKE_OPTIONS} \
    -S ${PROJECT_ROOT} \
    -B ${BUILD_DIR}

# Check if CMake configuration succeeded
if [ $? -ne 0 ]; then
    echo "CMake configuration failed"
    exit 1
fi

# Run build
${CMAKE} --build ${BUILD_DIR} --parallel ${JOBS}

# Check if build succeeded
if [ $? -ne 0 ]; then
    echo "Build failed"
    exit 1
fi

echo "Build succeeded"

#===================================== Prepare Resources =====================================

echo "Now, begin to prepare executing models & environment Resources!"

# Function: Safely change dir
change_directory() {
    local TARGET_DIR="$1"

    if [ -z "$TARGET_DIR" ]; then
        echo "Usage: change_directory <target_directory>"
        return 1
    fi

    if [ -d "$TARGET_DIR" ]; then
        cd "$TARGET_DIR" || { echo "Failed to change directory to $TARGET_DIR"; return 1; }
        echo "Successfully changed directory to $TARGET_DIR"
    else
        echo "Directory $TARGET_DIR does not exist"
        return 1
    fi

    return 0
}

change_directory "sd/"

# Check if the directory change was successful
if [ $? -eq 0 ]; then
    # Execute the auto_prepare_sd_models.sh script with the confirmation option
    bash ./auto_prepare_sd_models.sh $CONFIRM_OPTION
else
    echo "Failed to change directory. Exiting."
    exit 1
fi

echo "clitool is under $BUILD_DIR/bin/"

echo "All Finished! ready to maneuver, sir！"