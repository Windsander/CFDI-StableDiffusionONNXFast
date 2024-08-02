# CustomToolchain.cmake

# Check required variables
if(NOT DEFINED CMAKE_SYSTEM_NAME)
    message(FATAL_ERROR "CMAKE_SYSTEM_NAME is not set")
endif()

if(NOT DEFINED CMAKE_SYSTEM_PROCESSOR)
    message(FATAL_ERROR "CMAKE_SYSTEM_PROCESSOR is not set")

endif()
if(NOT DEFINED CMAKE_HOST_SYSTEM_NAME)
    execute_process(COMMAND uname -s OUTPUT_VARIABLE CMAKE_HOST_SYSTEM_NAME OUTPUT_STRIP_TRAILING_WHITESPACE)
endif()

if(NOT DEFINED CMAKE_HOST_SYSTEM_PROCESSOR)
    execute_process(COMMAND uname -m OUTPUT_VARIABLE CMAKE_HOST_SYSTEM_PROCESSOR OUTPUT_STRIP_TRAILING_WHITESPACE)
endif()

# Function to find and set the compiler
macro(find_cross_compiler)
    foreach(COMPILER ${ARGN})
        message(STATUS "Trying to find compiler [cross]: ${TARGET_TRIPLE}-${COMPILER}")
        find_program(C_COMPILER_PATH NAMES ${TARGET_TRIPLE}-${COMPILER} PATHS /usr/bin /usr/local/bin)
        if(C_COMPILER_PATH)
            # get_filename_component(C_COMPILER_DIR ${C_COMPILER_PATH} DIRECTORY)
            if(${COMPILER} MATCHES "clang")
                set(CMAKE_C_COMPILER ${TARGET_TRIPLE}-clang)
                set(CMAKE_CXX_COMPILER ${TARGET_TRIPLE}-clang++)
                set(CMAKE_C_FLAGS "-target ${TARGET_TRIPLE} --sysroot=${SYSROOT_PATH}")
                set(CMAKE_CXX_FLAGS "-target ${TARGET_TRIPLE} --sysroot=${SYSROOT_PATH}")
            elseif(${COMPILER} MATCHES "gcc")
                set(CMAKE_C_COMPILER ${TARGET_TRIPLE}-gcc)
                set(CMAKE_CXX_COMPILER ${TARGET_TRIPLE}-g++)
                set(CMAKE_C_FLAGS "-march=${TARGET_ARCH} --sysroot=${SYSROOT_PATH}")
                set(CMAKE_CXX_FLAGS "-march=${TARGET_ARCH} --sysroot=${SYSROOT_PATH}")
            elseif(${COMPILER} MATCHES "cl")
                set(CMAKE_C_COMPILER "${TARGET_TRIPLE}-cl")
                set(CMAKE_CXX_COMPILER "${TARGET_TRIPLE}-cl")
                set(CMAKE_C_FLAGS "/arch:${TARGET_ARCH}")
                set(CMAKE_CXX_FLAGS "/arch:${TARGET_ARCH}")
            endif()
            set(CMAKE_COMPILER_FOUND TRUE)
            message(STATUS "Found compiler: ${COMPILER} at ${C_COMPILER_PATH}")
            return()
        endif()
    endforeach()
    message(FATAL_ERROR "No suitable compiler found from the list: ${ARGN}")
endmacro()

macro(find_native_compiler)
    foreach(COMPILER ${ARGN})
        message(STATUS "Trying to find compiler [native]: ${COMPILER}")
        find_program(C_COMPILER_PATH NAMES ${COMPILER} PATHS /usr/bin /usr/local/bin)
        if(C_COMPILER_PATH)
            # get_filename_component(C_COMPILER_DIR ${C_COMPILER_PATH} DIRECTORY)
            if(${COMPILER} MATCHES "clang")
                set(CMAKE_C_COMPILER clang)
                set(CMAKE_CXX_COMPILER clang++)
                set(CMAKE_C_FLAGS "-target ${TARGET_TRIPLE}")
                set(CMAKE_CXX_FLAGS "-target ${TARGET_TRIPLE}")
            elseif(${COMPILER} MATCHES "gcc")
                set(CMAKE_C_COMPILER gcc)
                set(CMAKE_CXX_COMPILER g++)
                set(CMAKE_C_FLAGS "-march=${TARGET_ARCH}")
                set(CMAKE_CXX_FLAGS "-march=${TARGET_ARCH}")
            elseif(${COMPILER} MATCHES "cl")
                set(CMAKE_C_COMPILER "cl")
                set(CMAKE_CXX_COMPILER "cl")
                set(CMAKE_C_FLAGS "/arch:${TARGET_ARCH}")
                set(CMAKE_CXX_FLAGS "/arch:${TARGET_ARCH}")
            endif()
            set(CMAKE_COMPILER_FOUND TRUE)
            message(STATUS "Found compiler: ${COMPILER} at ${C_COMPILER_PATH}")
            return()
        endif()
    endforeach()
    message(FATAL_ERROR "No suitable compiler found from the list: ${ARGN}")
endmacro()

# Set compiler and flags based on system and processor
if(CMAKE_SYSTEM_NAME STREQUAL "Android")
    include(${CMAKE_CURRENT_SOURCE_DIR}/apex-toolchain/toolchain-android.cmake)
elseif(CMAKE_SYSTEM_NAME STREQUAL "Linux")
    include(${CMAKE_CURRENT_SOURCE_DIR}/apex-toolchain/toolchain-linux.cmake)
elseif(CMAKE_SYSTEM_NAME STREQUAL "Darwin")
    include(${CMAKE_CURRENT_SOURCE_DIR}/apex-toolchain/toolchain-darwin.cmake)
elseif(CMAKE_SYSTEM_NAME STREQUAL "Windows")
    include(${CMAKE_CURRENT_SOURCE_DIR}/apex-toolchain/toolchain-windows.cmake)
else()
    message(FATAL_ERROR "Unsupported system: ${CMAKE_SYSTEM_NAME}")
endif()