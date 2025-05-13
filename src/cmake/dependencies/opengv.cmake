# src/cmake/dependencies/opengv.cmake

# Build configuration for OpenGV

if(AV_BUILD_OPENGV)
    set(OPENGV_TARGET opengv)
    set(OPENGV_COMMIT "91f4b19c73450833a40e463ad3648aae80b3a7f3")
    
    # Check if this dependency needs to be rebuilt
    needs_rebuild(${OPENGV_TARGET} ${AV_DEPS_VERSION} OPENGV_NEEDS_REBUILD)
    
    if(OPENGV_NEEDS_REBUILD)
        message(STATUS "Building OpenGV ${OPENGV_COMMIT}")
        
        ExternalProject_Add(${OPENGV_TARGET}
            # Official repository
            # GIT_REPOSITORY https://github.com/laurentkneip/opengv.git
            # Our fork, with a fix:
            GIT_REPOSITORY https://github.com/alicevision/opengv.git
            # Use a custom commit with a fix to override the cxx standard from cmake command line
            GIT_TAG ${OPENGV_COMMIT}
            PREFIX ${BUILD_DIR}
            BUILD_IN_SOURCE 0
            BUILD_ALWAYS 0
            UPDATE_COMMAND ""
            SOURCE_DIR ${CMAKE_CURRENT_BINARY_DIR}/opengv
            BINARY_DIR ${BUILD_DIR}/opengv_build
            INSTALL_DIR ${CMAKE_INSTALL_PREFIX}
            CONFIGURE_COMMAND 
                ${CMAKE_COMMAND} 
                ${CMAKE_CORE_BUILD_FLAGS}
                ${EIGEN_CMAKE_FLAGS}
                -DCMAKE_INSTALL_PREFIX:PATH=<INSTALL_DIR>
		-DCMAKE_POLICY_VERSION_MINIMUM=3.5
                <SOURCE_DIR>
            BUILD_COMMAND $(MAKE) -j${CPU_CORES}
            DEPENDS eigen
        )
        
        # Add a step to mark this dependency as built
        add_mark_built_step(${OPENGV_TARGET} ${AV_DEPS_VERSION})
    else()
        message(STATUS "OpenGV ${OPENGV_COMMIT} already built, skipping")
        
        # Create dummy target for dependency tracking
        add_custom_target(${OPENGV_TARGET}
            COMMAND ${CMAKE_COMMAND} -E echo "OpenGV already built, skipping."
        )
    endif()
    
    # Register this dependency
    register_dependency(${OPENGV_TARGET})
    
    # Set flags for other dependencies that use OpenGV
    set(OPENGV_CMAKE_FLAGS -DOPENGV_DIR=${CMAKE_INSTALL_PREFIX})
endif()
