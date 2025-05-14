# src/cmake/dependencies/swig.cmake

# Build configuration for SWIG

if(AV_BUILD_SWIG)
    set(SWIG_TARGET SWIG)
    set(SWIG_VERSION "4.3.0") # Git tag
    
    # Check if this dependency needs to be rebuilt
    needs_rebuild(${SWIG_TARGET} ${AV_DEPS_VERSION} SWIG_NEEDS_REBUILD)
    
    if(SWIG_NEEDS_REBUILD)
        message(STATUS "Building SWIG ${SWIG_VERSION}")
        
        ExternalProject_Add(${SWIG_TARGET}
            GIT_REPOSITORY https://github.com/swig/swig
            GIT_TAG v${SWIG_VERSION}
            DOWNLOAD_DIR ${BUILD_DIR}/download/${SWIG_TARGET}
            DOWNLOAD_EXTRACT_TIMESTAMP TRUE
            PREFIX ${BUILD_DIR}
            BUILD_IN_SOURCE 0
            BUILD_ALWAYS 0
            UPDATE_COMMAND ""
            SOURCE_DIR ${CMAKE_CURRENT_BINARY_DIR}/${SWIG_TARGET}
            BINARY_DIR ${BUILD_DIR}/${SWIG_TARGET}_build
            INSTALL_DIR ${CMAKE_INSTALL_PREFIX}
            CONFIGURE_COMMAND ${CMAKE_COMMAND}
                ${CMAKE_CORE_BUILD_FLAGS}
                -DCMAKE_POLICY_VERSION_MINIMUM=3.8
                -DCMAKE_INSTALL_PREFIX:PATH=<INSTALL_DIR> <SOURCE_DIR>
            BUILD_COMMAND $(MAKE) -j${CPU_CORES}
        )
        
        # Add a step to mark this dependency as built
        add_mark_built_step(${SWIG_TARGET} ${AV_DEPS_VERSION})
    else()
        message(STATUS "SWIG ${SWIG_VERSION} already built, skipping")
        
        # Create dummy target for dependency tracking
        add_custom_target(${SWIG_TARGET}
            COMMAND ${CMAKE_COMMAND} -E echo "SWIG already built, skipping."
        )
    endif()
    
    # Register this dependency
    register_dependency(${SWIG_TARGET})
    
    # Set flags for other dependencies that use SWIG
    set(SWIG_CMAKE_FLAGS
        -DSWIG_DIR=${CMAKE_INSTALL_PREFIX}/share/swig/${SWIG_VERSION}
        -DSWIG_EXECUTABLE=${CMAKE_INSTALL_PREFIX}/bin-deps/swig
    )
endif()
