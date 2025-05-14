# src/cmake/dependencies/cctag.cmake

# Build configuration for CCTag

if(AV_BUILD_CCTAG)
    set(CCTAG_TARGET cctag)
    set(CCTAG_VERSION "v1.0.4") # Git tag
    
    # Check if this dependency needs to be rebuilt
    needs_rebuild(${CCTAG_TARGET} ${AV_DEPS_VERSION} CCTAG_NEEDS_REBUILD)
    
    if(CCTAG_NEEDS_REBUILD)
        message(STATUS "Building CCTag ${CCTAG_VERSION}")
        
        ExternalProject_Add(${CCTAG_TARGET}
            GIT_REPOSITORY https://github.com/alicevision/CCTag
            GIT_TAG ${CCTAG_VERSION}
            DOWNLOAD_EXTRACT_TIMESTAMP TRUE
            PREFIX ${BUILD_DIR}
            BUILD_IN_SOURCE 0
            BUILD_ALWAYS 0
            UPDATE_COMMAND ""
            SOURCE_DIR ${CMAKE_CURRENT_BINARY_DIR}/cctag
            BINARY_DIR ${BUILD_DIR}/cctag_build
            INSTALL_DIR ${CMAKE_INSTALL_PREFIX}
            CONFIGURE_COMMAND 
                ${CMAKE_COMMAND} 
                ${CMAKE_CORE_BUILD_FLAGS}
                ${BOOST_CMAKE_FLAGS}
                ${CUDA_CMAKE_FLAGS}
                ${OPENCV_CMAKE_FLAGS}
                ${EIGEN_CMAKE_FLAGS}
                ${TBB_CMAKE_FLAGS}
                -DCCTAG_WITH_CUDA:BOOL=${AV_USE_CUDA}
                -DCCTAG_BUILD_TESTS=OFF
                -DCCTAG_BUILD_APPS=OFF
                -DCCTAG_EIGEN_MEMORY_ALIGNMENT=ON
                -DCCTAG_CXX_STANDARD=17
                -DCMAKE_INSTALL_PREFIX:PATH=<INSTALL_DIR>
                -DCMAKE_POLICY_VERSION_MINIMUM=3.8
                <SOURCE_DIR>
            BUILD_COMMAND $(MAKE) -j${CPU_CORES}
            DEPENDS boost cuda opencv eigen tbb
        )
        
        # Add a step to mark this dependency as built
        add_mark_built_step(${CCTAG_TARGET} ${AV_DEPS_VERSION})
    else()
        message(STATUS "CCTag ${CCTAG_VERSION} already built, skipping")
        
        # Create dummy target for dependency tracking
        add_custom_target(${CCTAG_TARGET}
            COMMAND ${CMAKE_COMMAND} -E echo "CCTag already built, skipping."
        )
    endif()
    
    # Register this dependency
    register_dependency(${CCTAG_TARGET})
    
    # Set flags for other dependencies that use CCTag
    set(CCTAG_CMAKE_FLAGS -DCCTag_DIR:PATH=${CMAKE_INSTALL_PREFIX}/lib/cmake/CCTag)
endif()
