# src/cmake/dependencies/expat.cmake

# Build configuration for Expat

if(AV_BUILD_EXPAT)
    set(EXPAT_TARGET expat)
    set(EXPAT_VERSION "R_2_7_1") # Git tag
    
    # Check if this dependency needs to be rebuilt
    needs_rebuild(${EXPAT_TARGET} ${AV_DEPS_VERSION} EXPAT_NEEDS_REBUILD)
    
    if(EXPAT_NEEDS_REBUILD)
        message(STATUS "Building Expat ${EXPAT_VERSION}")
        
        ExternalProject_Add(${EXPAT_TARGET}
            GIT_REPOSITORY https://github.com/libexpat/libexpat.git
            GIT_TAG ${EXPAT_VERSION}
            DOWNLOAD_EXTRACT_TIMESTAMP TRUE
            PREFIX ${BUILD_DIR}
            BUILD_IN_SOURCE 0
            BUILD_ALWAYS 0
            UPDATE_COMMAND ""
            SOURCE_DIR ${CMAKE_CURRENT_BINARY_DIR}/expat
            BINARY_DIR ${BUILD_DIR}/libexpat_build
            INSTALL_DIR ${CMAKE_INSTALL_PREFIX}
            CONFIGURE_COMMAND ${CMAKE_COMMAND} ${CMAKE_CORE_BUILD_FLAGS}
                -DEXPAT_BUILD_DOCS:BOOL=OFF
                -DEXPAT_BUILD_EXAMPLES:BOOL=OFF
                -DEXPAT_BUILD_TOOLS:BOOL=OFF
                -DCMAKE_INSTALL_PREFIX:PATH=<INSTALL_DIR>
                -DCMAKE_POLICY_VERSION_MINIMUM=3.8
                <SOURCE_DIR>/expat
            BUILD_COMMAND $(MAKE) -j${CPU_CORES}
        )
        
        # Add a step to mark this dependency as built
        add_mark_built_step(${EXPAT_TARGET} ${AV_DEPS_VERSION})
    else()
        message(STATUS "Expat ${EXPAT_VERSION} already built, skipping")
        
        # Create dummy target for dependency tracking
        add_custom_target(${EXPAT_TARGET}
            COMMAND ${CMAKE_COMMAND} -E echo "Expat already built, skipping."
        )
    endif()
    
    # Register this dependency
    register_dependency(${EXPAT_TARGET})
    
    # Set flags for other dependencies that use Expat
    set(EXPAT_CMAKE_FLAGS 
        -DEXPAT_INCLUDE_DIR=${CMAKE_INSTALL_PREFIX}/include
        -DEXPAT_LIBRARY=${CMAKE_INSTALL_PREFIX}/lib/libexpat${CMAKE_SHARED_LIBRARY_SUFFIX}
    )
endif()
