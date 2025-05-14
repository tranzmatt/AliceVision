# src/cmake/dependencies/onnxruntime.cmake

# Build configuration for ONNXRuntime

if(AV_BUILD_ONNXRUNTIME)
    set(ONNXRUNTIME_TARGET onnxruntime)
    set(AV_ONNX_VERSION "1.12.0")
    
    # Check if this dependency needs to be rebuilt
    needs_rebuild(${ONNXRUNTIME_TARGET} ${AV_DEPS_VERSION} ONNXRUNTIME_NEEDS_REBUILD)
    
    if(ONNXRUNTIME_NEEDS_REBUILD)
        message(STATUS "Building ONNXRuntime ${AV_ONNX_VERSION}")
        
        # Determine platform-specific filename and hash
        if(APPLE)
            set(AV_ONNX_FILENAME_PREFIX "onnxruntime-osx-${AV_ONNX_APPLE_ARCH}")
            if(AV_ONNX_APPLE_ARCH STREQUAL "arm64")
                set(AV_ONNX_HASH "23117b6f5d7324d4a7c51184e5f808dd952aec411a6b99a1b6fd1011de06e300")
            elseif(AV_ONNX_APPLE_ARCH STREQUAL "x86_64")
                set(AV_ONNX_HASH "09b17f712f8c6f19bb63da35d508815b443cbb473e16c6192abfaa297c02f600")
            else()
                message(FATAL_ERROR "Unsupported arch version ${AV_ONNX_APPLE_ARCH} for Apple")
            endif()
        else()
            string(FIND "${CMAKE_HOST_SYSTEM_PROCESSOR}" "aarch64" POSITION)
            if(NOT POSITION EQUAL -1)
                set(AV_ONNX_FILENAME_PREFIX "onnxruntime-linux-aarch64")
                set(AV_ONNX_HASH "5820d9f343df73c63b6b2b174a1ff62575032e171c9564bcf92060f46827d0ac")
            else()        
                set(AV_ONNX_FILENAME_PREFIX "onnxruntime-linux-x64")
                set(AV_ONNX_HASH "5d503ce8540358b59be26c675e42081be14a3e833a5301926f555451046929c5")
            endif()
        endif()

        set(AV_ONNX_FILENAME "${AV_ONNX_FILENAME_PREFIX}-${AV_ONNX_VERSION}.tgz")
        
        ExternalProject_Add(${ONNXRUNTIME_TARGET}
            URL https://github.com/microsoft/onnxruntime/releases/download/v${AV_ONNX_VERSION}/${AV_ONNX_FILENAME}
            URL_HASH SHA256=${AV_ONNX_HASH}
            DOWNLOAD_DIR ${BUILD_DIR}/download/onnxruntime
            DOWNLOAD_EXTRACT_TIMESTAMP TRUE
            SOURCE_DIR ${CMAKE_CURRENT_BINARY_DIR}/onnxruntime
            INSTALL_DIR ${CMAKE_INSTALL_PREFIX}
            PREFIX ${BUILD_DIR}
            INSTALL_COMMAND sh -c "mkdir -p <INSTALL_DIR>/include <INSTALL_DIR>/lib && cp -r <SOURCE_DIR>/lib/* <INSTALL_DIR>/lib && cp -r <SOURCE_DIR>/include/* <INSTALL_DIR>/include"
            CONFIGURE_COMMAND ""
            UPDATE_COMMAND ""
            BUILD_COMMAND ""
            BUILD_ALWAYS 0
            BUILD_IN_SOURCE 0
        )
        
        # Add a step to mark this dependency as built
        add_mark_built_step(${ONNXRUNTIME_TARGET} ${AV_DEPS_VERSION})
    else()
        message(STATUS "ONNXRuntime ${AV_ONNX_VERSION} already built, skipping")
        
        # Create dummy target for dependency tracking
        add_custom_target(${ONNXRUNTIME_TARGET}
            COMMAND ${CMAKE_COMMAND} -E echo "ONNXRuntime already built, skipping."
        )
    endif()
    
    # Register this dependency
    register_dependency(${ONNXRUNTIME_TARGET})
    
    # Set flags for dependencies that use ONNXRuntime
    set(ONNXRUNTIME_CMAKE_FLAGS
        -DONNXRuntime_DIR=${CMAKE_INSTALL_PREFIX}/lib/cmake/ONNXRuntime
        -DONNXRuntime_INCLUDE_DIR=${CMAKE_INSTALL_PREFIX}/include
    )
endif()
