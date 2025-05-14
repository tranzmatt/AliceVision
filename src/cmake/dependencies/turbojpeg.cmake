# src/cmake/dependencies/turbojpeg.cmake

# Build configuration for TurboJPEG

if(AV_BUILD_JPEG)
    set(JPEG_TARGET turbojpeg)
    set(JPEG_VERSION "3.1.0")
    set(JPEG_HASH "MD5=1695d39ba38a9593f4107722f3459fe0")
    
    # Check if this dependency needs to be rebuilt
    needs_rebuild(${JPEG_TARGET} ${AV_DEPS_VERSION} JPEG_NEEDS_REBUILD)
    
    if(JPEG_NEEDS_REBUILD)
        message(STATUS "Building TurboJPEG ${JPEG_VERSION}")
        
        ExternalProject_Add(${JPEG_TARGET}
            URL https://github.com/libjpeg-turbo/libjpeg-turbo/archive/${JPEG_VERSION}.tar.gz
            URL_HASH ${JPEG_HASH}
            DOWNLOAD_DIR ${BUILD_DIR}/download/libjpeg-turbo
            DOWNLOAD_EXTRACT_TIMESTAMP TRUE
            PREFIX ${BUILD_DIR}
            BUILD_IN_SOURCE 0
            BUILD_ALWAYS 0
            UPDATE_COMMAND ""
            SOURCE_DIR ${CMAKE_CURRENT_BINARY_DIR}/turbojpeg
            BINARY_DIR ${CMAKE_CURRENT_BINARY_DIR}/turbojpeg_build
            INSTALL_DIR ${CMAKE_INSTALL_PREFIX}
            CONFIGURE_COMMAND 
                ${CMAKE_COMMAND} 
                ${CMAKE_CORE_BUILD_FLAGS}
                ${ZLIB_CMAKE_FLAGS}
                -DCMAKE_INSTALL_PREFIX=<INSTALL_DIR>
                -DCMAKE_POLICY_VERSION_MINIMUM=3.8
                <SOURCE_DIR>
            BUILD_COMMAND $(MAKE) -j${CPU_CORES}
            INSTALL_COMMAND $(MAKE) install
            DEPENDS zlib
        )
        
        # Add a step to mark this dependency as built
        add_mark_built_step(${JPEG_TARGET} ${AV_DEPS_VERSION})
    else()
        message(STATUS "TurboJPEG ${JPEG_VERSION} already built, skipping")
        
        # Create dummy target for dependency tracking
        add_custom_target(${JPEG_TARGET}
            COMMAND ${CMAKE_COMMAND} -E echo "TurboJPEG already built, skipping."
        )
    endif()
    
    # Register this dependency
    register_dependency(${JPEG_TARGET})
    
    # Set flags for other dependencies that use JPEG
    set(JPEG_CMAKE_FLAGS 
        -DJPEG_LIBRARY=${CMAKE_INSTALL_PREFIX}/${CMAKE_INSTALL_LIBDIR}/libjpeg${CMAKE_SHARED_LIBRARY_SUFFIX} 
        -DJPEG_INCLUDE_DIR=${CMAKE_INSTALL_PREFIX}/include
    )
endif()
