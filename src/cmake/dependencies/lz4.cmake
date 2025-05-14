# src/cmake/dependencies/lz4.cmake

# Build configuration for LZ4

if(AV_BUILD_LZ4)
    set(LZ4_TARGET lz4)
    set(LZ4_VERSION "1.10.0")
    
    # Check if this dependency needs to be rebuilt
    needs_rebuild(${LZ4_TARGET} ${AV_DEPS_VERSION} LZ4_NEEDS_REBUILD)
    
    if(LZ4_NEEDS_REBUILD)
        message(STATUS "Building LZ4 ${LZ4_VERSION}")
        
        ExternalProject_Add(${LZ4_TARGET}
            GIT_REPOSITORY https://github.com/lz4/lz4
            GIT_TAG v${LZ4_VERSION}
            DOWNLOAD_EXTRACT_TIMESTAMP TRUE
            PREFIX ${BUILD_DIR}
            BUILD_IN_SOURCE 0
            BUILD_ALWAYS 0
            UPDATE_COMMAND ""
            SOURCE_DIR ${CMAKE_CURRENT_BINARY_DIR}/${LZ4_TARGET}
            BINARY_DIR ${BUILD_DIR}/${LZ4_TARGET}_build
            INSTALL_DIR ${CMAKE_INSTALL_PREFIX}
            CONFIGURE_COMMAND ${CMAKE_COMMAND} 
                ${CMAKE_CORE_BUILD_FLAGS}
                -DCMAKE_INSTALL_PREFIX:PATH=<INSTALL_DIR>
                -DCMAKE_POLICY_VERSION_MINIMUM=3.8
                <SOURCE_DIR>/build/cmake/
            BUILD_COMMAND $(MAKE) -j${CPU_CORES}
            INSTALL_COMMAND $(MAKE) -j${CPU_CORES} install 
        )
        
        # Add a step to mark this dependency as built
        add_mark_built_step(${LZ4_TARGET} ${AV_DEPS_VERSION})
    else()
        message(STATUS "LZ4 ${LZ4_VERSION} already built, skipping")
        
        # Create dummy target for dependency tracking
        add_custom_target(${LZ4_TARGET}
            COMMAND ${CMAKE_COMMAND} -E echo "LZ4 already built, skipping."
        )
    endif()
    
    # Register this dependency
    register_dependency(${LZ4_TARGET})
    
    # Set flags for other dependencies that use LZ4
    set(LZ4_CMAKE_FLAGS -Dlz4_DIR:PATH=${CMAKE_INSTALL_PREFIX}/lib/cmake/lz4/)
endif()
