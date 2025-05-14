# src/cmake/dependencies/tbb.cmake

# Build configuration for Intel Threading Building Blocks (TBB)

if(AV_BUILD_TBB)
    set(TBB_TARGET tbb)
    set(TBB_VERSION "2022.1.0")
    set(TBB_HASH "MD5=cce28e6cb1ceae14a93848990c98cb6b")
    
    # Check if this dependency needs to be rebuilt
    needs_rebuild(${TBB_TARGET} ${AV_DEPS_VERSION} TBB_NEEDS_REBUILD)
    
    if(TBB_NEEDS_REBUILD)
        message(STATUS "Building TBB ${TBB_VERSION}")
        
        ExternalProject_Add(${TBB_TARGET}
            URL https://github.com/oneapi-src/oneTBB/archive/refs/tags/v${TBB_VERSION}.tar.gz
            URL_HASH ${TBB_HASH}
            DOWNLOAD_DIR ${BUILD_DIR}/download/tbb
            DOWNLOAD_EXTRACT_TIMESTAMP TRUE
            PREFIX ${BUILD_DIR}
            BUILD_IN_SOURCE 0
            BUILD_ALWAYS 0
            UPDATE_COMMAND ""
            SOURCE_DIR ${CMAKE_CURRENT_BINARY_DIR}/tbb
            BINARY_DIR ${BUILD_DIR}/tbb_build
            INSTALL_DIR ${CMAKE_INSTALL_PREFIX}
            CONFIGURE_COMMAND ${CMAKE_COMMAND} 
                ${CMAKE_CORE_BUILD_FLAGS} 
                -DTBB_TEST:BOOL=OFF 
                -DTBB_STRICT:BOOL=OFF 
                -DCMAKE_INSTALL_PREFIX:PATH=<INSTALL_DIR>  
                -DCMAKE_POLICY_VERSION_MINIMUM=3.8
                <SOURCE_DIR>
            BUILD_COMMAND $(MAKE) -j${CPU_CORES}
        )
        
        # Add a step to mark this dependency as built
        add_mark_built_step(${TBB_TARGET} ${AV_DEPS_VERSION})
    else()
        message(STATUS "TBB ${TBB_VERSION} already built, skipping")
        
        # Create dummy target for dependency tracking
        add_custom_target(${TBB_TARGET}
            COMMAND ${CMAKE_COMMAND} -E echo "TBB already built, skipping."
        )
    endif()
    
    # Register this dependency
    register_dependency(${TBB_TARGET})
    
    # Set flags for other dependencies that use TBB
    set(TBB_CMAKE_FLAGS -DTBB_DIR:PATH=${CMAKE_INSTALL_PREFIX}/lib/cmake/TBB)
endif()
