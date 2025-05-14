# src/cmake/dependencies/coinutils.cmake

# Build configuration for CoinUtils

if(AV_BUILD_COINUTILS)
    set(COINUTILS_TARGET coinutils)
    set(COINUTILS_COMMIT "b29532e31471d26dddee99095da3340e80e8c60c") # Git commit hash
    
    # Check if this dependency needs to be rebuilt
    needs_rebuild(${COINUTILS_TARGET} ${AV_DEPS_VERSION} COINUTILS_NEEDS_REBUILD)
    
    if(COINUTILS_NEEDS_REBUILD)
        message(STATUS "Building CoinUtils ${COINUTILS_COMMIT}")
        
        ExternalProject_Add(${COINUTILS_TARGET}
            GIT_REPOSITORY https://github.com/alicevision/CoinUtils
            GIT_TAG ${COINUTILS_COMMIT}
            PREFIX ${BUILD_DIR}
            BUILD_IN_SOURCE 0
            BUILD_ALWAYS 0
            UPDATE_COMMAND ""
            SOURCE_DIR ${CMAKE_CURRENT_BINARY_DIR}/coinutils
            BINARY_DIR ${BUILD_DIR}/coinutils_build
            INSTALL_DIR ${CMAKE_INSTALL_PREFIX}
            CONFIGURE_COMMAND 
                ${CMAKE_COMMAND} 
                ${CMAKE_CORE_BUILD_FLAGS}
                -DCMAKE_INSTALL_PREFIX:PATH=<INSTALL_DIR>
                <SOURCE_DIR>
            BUILD_COMMAND $(MAKE) -j${CPU_CORES}
        )
        
        # Add a step to mark this dependency as built
        add_mark_built_step(${COINUTILS_TARGET} ${AV_DEPS_VERSION})
    else()
        message(STATUS "CoinUtils ${COINUTILS_COMMIT} already built, skipping")
        
        # Create dummy target for dependency tracking
        add_custom_target(${COINUTILS_TARGET}
            COMMAND ${CMAKE_COMMAND} -E echo "CoinUtils already built, skipping."
        )
    endif()
    
    # Register this dependency
    register_dependency(${COINUTILS_TARGET})
    
    # Set flags for other dependencies that use CoinUtils
    set(COINUTILS_CMAKE_FLAGS -DCoinUtils_DIR:PATH=${CMAKE_INSTALL_PREFIX}/share/coinutils)
endif()