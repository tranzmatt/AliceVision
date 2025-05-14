# src/cmake/dependencies/popsift.cmake

# Build configuration for PopSift

if(AV_BUILD_POPSIFT)
    set(POPSIFT_TARGET popsift)
    set(POPSIFT_COMMIT "4b4b2478d5f0cdb6c4215a031572e951c0c2502e") # Git commit hash
    
    # Check if this dependency needs to be rebuilt
    needs_rebuild(${POPSIFT_TARGET} ${AV_DEPS_VERSION} POPSIFT_NEEDS_REBUILD)
    
    if(POPSIFT_NEEDS_REBUILD)
        message(STATUS "Building PopSift ${POPSIFT_COMMIT}")
        
        ExternalProject_Add(${POPSIFT_TARGET}
            GIT_REPOSITORY https://github.com/alicevision/popsift
            GIT_TAG ${POPSIFT_COMMIT}
            PREFIX ${BUILD_DIR}
            BUILD_IN_SOURCE 0
            BUILD_ALWAYS 0
            UPDATE_COMMAND ""
            SOURCE_DIR ${CMAKE_CURRENT_BINARY_DIR}/popsift
            BINARY_DIR ${BUILD_DIR}/popsift_build
            INSTALL_DIR ${CMAKE_INSTALL_PREFIX}
            CONFIGURE_COMMAND 
                ${CMAKE_COMMAND} 
                ${CMAKE_CORE_BUILD_FLAGS}
                ${BOOST_CMAKE_FLAGS}
                ${CUDA_CMAKE_FLAGS}
                -DPopSift_BUILD_EXAMPLES:BOOL=OFF
                -DCMAKE_INSTALL_PREFIX:PATH=<INSTALL_DIR>
                <SOURCE_DIR>
            BUILD_COMMAND $(MAKE) -j${CPU_CORES}
            DEPENDS boost cuda
        )
        
        # Add a step to mark this dependency as built
        add_mark_built_step(${POPSIFT_TARGET} ${AV_DEPS_VERSION})
    else()
        message(STATUS "PopSift ${POPSIFT_COMMIT} already built, skipping")
        
        # Create dummy target for dependency tracking
        add_custom_target(${POPSIFT_TARGET}
            COMMAND ${CMAKE_COMMAND} -E echo "PopSift already built, skipping."
        )
    endif()
    
    # Register this dependency
    register_dependency(${POPSIFT_TARGET})
    
    # Set flags for other dependencies that use PopSift
    set(POPSIFT_CMAKE_FLAGS -DPopSift_DIR:PATH=${CMAKE_INSTALL_PREFIX}/lib/cmake/PopSift)
endif()