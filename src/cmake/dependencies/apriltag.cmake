# src/cmake/dependencies/apriltag.cmake

# Build configuration for AprilTag

if(AV_BUILD_APRILTAG)
    set(APRILTAG_TARGET apriltag)
    set(APRILTAG_VERSION "v3.2.0") # Git tag
    
    # Check if this dependency needs to be rebuilt
    needs_rebuild(${APRILTAG_TARGET} ${AV_DEPS_VERSION} APRILTAG_NEEDS_REBUILD)
    
    if(APRILTAG_NEEDS_REBUILD)
        message(STATUS "Building AprilTag ${APRILTAG_VERSION}")
        
        ExternalProject_Add(${APRILTAG_TARGET}
            GIT_REPOSITORY https://github.com/AprilRobotics/apriltag
            GIT_TAG ${APRILTAG_VERSION}
            PREFIX ${BUILD_DIR}
            DOWNLOAD_EXTRACT_TIMESTAMP TRUE
            BUILD_IN_SOURCE 0
            BUILD_ALWAYS 0
            UPDATE_COMMAND ""
            SOURCE_DIR ${CMAKE_CURRENT_BINARY_DIR}/apriltag
            BINARY_DIR ${BUILD_DIR}/apriltag_build
            INSTALL_DIR ${CMAKE_INSTALL_PREFIX}
            CONFIGURE_COMMAND 
                ${CMAKE_COMMAND} 
                ${CMAKE_CORE_BUILD_FLAGS}
                -DBUILD_PYTHON_WRAPPER=OFF
                -DOpenCV_FOUND=OFF
                -DCMAKE_INSTALL_PREFIX:PATH=<INSTALL_DIR>
                -DCMAKE_POLICY_VERSION_MINIMUM=3.8
                <SOURCE_DIR>
            BUILD_COMMAND $(MAKE) -j${CPU_CORES}
        )
        
        # Add a step to mark this dependency as built
        add_mark_built_step(${APRILTAG_TARGET} ${AV_DEPS_VERSION})
    else()
        message(STATUS "AprilTag ${APRILTAG_VERSION} already built, skipping")
        
        # Create dummy target for dependency tracking
        add_custom_target(${APRILTAG_TARGET}
            COMMAND ${CMAKE_COMMAND} -E echo "AprilTag already built, skipping."
        )
    endif()
    
    # Register this dependency
    register_dependency(${APRILTAG_TARGET})
    
    # Set flags for other dependencies that use AprilTag
    set(APRILTAG_CMAKE_FLAGS -Dapriltag_DIR:PATH=${CMAKE_INSTALL_PREFIX}/share/apriltag/cmake)
endif()
