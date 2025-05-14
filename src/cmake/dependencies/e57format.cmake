# src/cmake/dependencies/e57format.cmake

# Build configuration for E57Format

if(AV_BUILD_E57FORMAT)
    set(E57FORMAT_TARGET E57Format)
    set(E57FORMAT_VERSION "v3.1.1") # Git tag
    
    # Check if this dependency needs to be rebuilt
    needs_rebuild(${E57FORMAT_TARGET} ${AV_DEPS_VERSION} E57FORMAT_NEEDS_REBUILD)
    
    if(E57FORMAT_NEEDS_REBUILD)
        message(STATUS "Building E57Format ${E57FORMAT_VERSION}")
        
        ExternalProject_add(${E57FORMAT_TARGET}
            GIT_REPOSITORY https://github.com/asmaloney/libE57Format.git
            GIT_TAG ${E57FORMAT_VERSION}
            DOWNLOAD_DIR ${BUILD_DIR}/download/${E57FORMAT_TARGET}
            PREFIX ${BUILD_DIR}
            BUILD_IN_SOURCE 0
            BUILD_ALWAYS 0
            UPDATE_COMMAND ""
            SOURCE_DIR ${CMAKE_CURRENT_BINARY_DIR}/${E57FORMAT_TARGET}
            BINARY_DIR ${BUILD_DIR}/${E57FORMAT_TARGET}_build
            INSTALL_DIR ${CMAKE_INSTALL_PREFIX}
            CONFIGURE_COMMAND ${CMAKE_COMMAND}
                ${CMAKE_CORE_BUILD_FLAGS}
                -DCMAKE_INSTALL_PREFIX:PATH=<INSTALL_DIR> <SOURCE_DIR>
            BUILD_COMMAND $(MAKE) -j${CPU_CORES}
        )
        
        # Add a step to mark this dependency as built
        add_mark_built_step(${E57FORMAT_TARGET} ${AV_DEPS_VERSION})
    else()
        message(STATUS "E57Format ${E57FORMAT_VERSION} already built, skipping")
        
        # Create dummy target for dependency tracking
        add_custom_target(${E57FORMAT_TARGET}
            COMMAND ${CMAKE_COMMAND} -E echo "E57Format already built, skipping."
        )
    endif()
    
    # Register this dependency
    register_dependency(${E57FORMAT_TARGET})
    
    # Set flags for other dependencies that use E57Format
    set(E57FORMAT_CMAKE_FLAGS -DE57FORMAT_DIR:PATH=${CMAKE_INSTALL_PREFIX}/share/E57Format)
endif()