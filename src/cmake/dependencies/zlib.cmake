# src/cmake/dependencies/zlib.cmake

# Build configuration for ZLIB

if(AV_BUILD_ZLIB)
    set(ZLIB_VERSION "1.3.1")
    set(ZLIB_TARGET zlib)
    set(ZLIB_HASH "SHA256=9a93b2b7dfdac77ceba5a558a580e74667dd6fede4585b91eefb60f03b72df23")
    
    # Check if this dependency needs to be rebuilt
    needs_rebuild(${ZLIB_TARGET} ${AV_DEPS_VERSION} ZLIB_NEEDS_REBUILD)
    
    if(ZLIB_NEEDS_REBUILD)
        message(STATUS "Building ZLIB ${ZLIB_VERSION}")
        
        ExternalProject_Add(${ZLIB_TARGET}
            URL https://www.zlib.net/zlib-${ZLIB_VERSION}.tar.gz
            URL_HASH ${ZLIB_HASH}
            DOWNLOAD_DIR ${BUILD_DIR}/download/zlib
            PREFIX ${BUILD_DIR}
            BUILD_IN_SOURCE 0
            BUILD_ALWAYS 0
            UPDATE_COMMAND ""
            SOURCE_DIR ${CMAKE_CURRENT_BINARY_DIR}/zlib
            BINARY_DIR ${BUILD_DIR}/zlib_build
            INSTALL_DIR ${CMAKE_INSTALL_PREFIX}
            CONFIGURE_COMMAND 
                ${CMAKE_COMMAND} 
                ${CMAKE_CORE_BUILD_FLAGS}
                -DCMAKE_INSTALL_PREFIX:PATH=<INSTALL_DIR>
                <SOURCE_DIR>
            BUILD_COMMAND $(MAKE) -j${CPU_CORES}
        )
        
        # Add a step to mark this dependency as built
        add_mark_built_step(${ZLIB_TARGET} ${AV_DEPS_VERSION})
    else()
        message(STATUS "ZLIB ${ZLIB_VERSION} already built, skipping")
        
        # Create dummy target for dependency tracking
        add_custom_target(${ZLIB_TARGET}
            COMMAND ${CMAKE_COMMAND} -E echo "ZLIB already built, skipping."
        )
    endif()
    
    # Register this dependency
    register_dependency(${ZLIB_TARGET})
    
    # Set flags for other dependencies that use ZLIB
    set(ZLIB_CMAKE_FLAGS -DZLIB_ROOT=${CMAKE_INSTALL_PREFIX})
endif()