# src/cmake/dependencies/tiff.cmake

# Build configuration for TIFF

if(AV_BUILD_TIFF)
    set(TIFF_TARGET tiff)
    set(TIFF_VERSION "4.5.0")
    set(TIFF_HASH "MD5=db9e220a1971acc64487f1d51a20dcaa")
    
    # Check if this dependency needs to be rebuilt
    needs_rebuild(${TIFF_TARGET} ${AV_DEPS_VERSION} TIFF_NEEDS_REBUILD)
    
    if(TIFF_NEEDS_REBUILD)
        message(STATUS "Building TIFF ${TIFF_VERSION}")
        
        ExternalProject_Add(${TIFF_TARGET}
            URL http://download.osgeo.org/libtiff/tiff-${TIFF_VERSION}.tar.gz
            URL_HASH ${TIFF_HASH}
            DOWNLOAD_DIR ${BUILD_DIR}/download/tiff
            PREFIX ${BUILD_DIR}
            BUILD_IN_SOURCE 0
            BUILD_ALWAYS 0
            UPDATE_COMMAND ""
            SOURCE_DIR ${CMAKE_CURRENT_BINARY_DIR}/tiff
            BINARY_DIR ${BUILD_DIR}/tiff_build
            INSTALL_DIR ${CMAKE_INSTALL_PREFIX}
            CONFIGURE_COMMAND <SOURCE_DIR>/configure 
                --prefix=<INSTALL_DIR>
                --disable-tests
                --disable-docs
                --disable-tools
            BUILD_COMMAND $(MAKE) -j${CPU_CORES}
            INSTALL_COMMAND $(MAKE) install
            DEPENDS zlib
        )
        
        # Add a step to mark this dependency as built
        add_mark_built_step(${TIFF_TARGET} ${AV_DEPS_VERSION})
    else()
        message(STATUS "TIFF ${TIFF_VERSION} already built, skipping")
        
        # Create dummy target for dependency tracking
        add_custom_target(${TIFF_TARGET}
            COMMAND ${CMAKE_COMMAND} -E echo "TIFF already built, skipping."
        )
    endif()
    
    # Register this dependency
    register_dependency(${TIFF_TARGET})
    
    # Set flags for other dependencies that use TIFF
    set(TIFF_CMAKE_FLAGS 
        -DTIFF_LIBRARY=${CMAKE_INSTALL_PREFIX}/lib/libtiff${CMAKE_SHARED_LIBRARY_SUFFIX} 
        -DTIFF_INCLUDE_DIR=${CMAKE_INSTALL_PREFIX}/include
    )
endif()