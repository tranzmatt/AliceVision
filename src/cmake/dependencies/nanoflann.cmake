# src/cmake/dependencies/nanoflann.cmake

# Build configuration for NanoFLANN

if(AV_BUILD_NANOFLANN)
    set(NANOFLANN_TARGET nanoflann)
    set(NANOFLANN_COMMIT "419c26c498d12231817ada6488e2fd2442dbc68d") # Git commit hash
    
    # Check if this dependency needs to be rebuilt
    needs_rebuild(${NANOFLANN_TARGET} ${AV_DEPS_VERSION} NANOFLANN_NEEDS_REBUILD)
    
    if(NANOFLANN_NEEDS_REBUILD)
        message(STATUS "Building NanoFLANN ${NANOFLANN_COMMIT}")
        
        ExternalProject_Add(${NANOFLANN_TARGET}
            GIT_REPOSITORY https://github.com/jlblancoc/nanoflann
            GIT_TAG ${NANOFLANN_COMMIT}
            DOWNLOAD_EXTRACT_TIMESTAMP TRUE
            PREFIX ${BUILD_DIR}
            BUILD_IN_SOURCE 0
            BUILD_ALWAYS 0
            UPDATE_COMMAND ""
            SOURCE_DIR ${CMAKE_CURRENT_BINARY_DIR}/${NANOFLANN_TARGET}
            BINARY_DIR ${BUILD_DIR}/${NANOFLANN_TARGET}_build
            INSTALL_DIR ${CMAKE_INSTALL_PREFIX}
            CONFIGURE_COMMAND 
                ${CMAKE_COMMAND} -E env PKG_CONFIG_PATH=${CMAKE_INSTALL_PREFIX}/lib64/pkgconfig/
                ${CMAKE_COMMAND} 
                ${CMAKE_CORE_BUILD_FLAGS}
                -DNANOFLANN_BUILD_EXAMPLES=OFF
                -DNANOFLANN_BUILD_TESTS=OFF
                -DCMAKE_POLICY_VERSION_MINIMUM=3.8
                -DCMAKE_INSTALL_PREFIX:PATH=<INSTALL_DIR> <SOURCE_DIR>
                -DCMAKE_INSTALL_LIBDIR=lib
            BUILD_COMMAND $(MAKE) -j${CPU_CORES}
            INSTALL_COMMAND $(MAKE) -j${CPU_CORES} install
        )
        
        # Add a step to mark this dependency as built
        add_mark_built_step(${NANOFLANN_TARGET} ${AV_DEPS_VERSION})
    else()
        message(STATUS "NanoFLANN ${NANOFLANN_COMMIT} already built, skipping")
        
        # Create dummy target for dependency tracking
        add_custom_target(${NANOFLANN_TARGET}
            COMMAND ${CMAKE_COMMAND} -E echo "NanoFLANN already built, skipping."
        )
    endif()
    
    # Register this dependency
    register_dependency(${NANOFLANN_TARGET})
    
    # Set flags for other dependencies that use NanoFLANN
    set(NANOFLANN_CMAKE_FLAGS -Dnanoflann_DIR:PATH=${CMAKE_INSTALL_PREFIX}/lib/cmake/nanoflann/)
endif()
