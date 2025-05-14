# src/cmake/dependencies/lemon.cmake

# Build configuration for LEMON (Library for Efficient Modeling and Optimization in Networks)

if(AV_BUILD_LEMON)
    set(LEMON_TARGET LEMON)
    set(LEMON_COMMIT "90244e2b16301d286ca5087fbb3f0130b6a1812e") # Git commit hash
    
    # Check if this dependency needs to be rebuilt
    needs_rebuild(${LEMON_TARGET} ${AV_DEPS_VERSION} LEMON_NEEDS_REBUILD)
    
    if(LEMON_NEEDS_REBUILD)
        message(STATUS "Building LEMON ${LEMON_COMMIT}")
        
        ExternalProject_Add(${LEMON_TARGET}
            GIT_REPOSITORY https://github.com/alicevision/lemon.git
            GIT_TAG ${LEMON_COMMIT}
            DOWNLOAD_DIR ${BUILD_DIR}/download/${LEMON_TARGET}
            DOWNLOAD_EXTRACT_TIMESTAMP TRUE
            PREFIX ${BUILD_DIR}
            BUILD_IN_SOURCE 0
            BUILD_ALWAYS 0
            UPDATE_COMMAND ""
            SOURCE_DIR ${CMAKE_CURRENT_BINARY_DIR}/${LEMON_TARGET}
            BINARY_DIR ${BUILD_DIR}/${LEMON_TARGET}_build
            INSTALL_DIR ${CMAKE_INSTALL_PREFIX}
            CONFIGURE_COMMAND ${CMAKE_COMMAND}
                ${CMAKE_CORE_BUILD_FLAGS}
                -DCMAKE_POLICY_VERSION_MINIMUM=3.8
                -DCMAKE_INSTALL_PREFIX:PATH=<INSTALL_DIR> <SOURCE_DIR>
            BUILD_COMMAND $(MAKE) -j${CPU_CORES}
        )
        
        # Add a step to mark this dependency as built
        add_mark_built_step(${LEMON_TARGET} ${AV_DEPS_VERSION})
    else()
        message(STATUS "LEMON ${LEMON_COMMIT} already built, skipping")
        
        # Create dummy target for dependency tracking
        add_custom_target(${LEMON_TARGET}
            COMMAND ${CMAKE_COMMAND} -E echo "LEMON already built, skipping."
        )
    endif()
    
    # Register this dependency
    register_dependency(${LEMON_TARGET})
    
    # Set flags for other dependencies that use LEMON
    set(LEMON_CMAKE_FLAGS -DLEMON_DIR:PATH=${CMAKE_INSTALL_PREFIX}/share/lemon/cmake)
endif()
