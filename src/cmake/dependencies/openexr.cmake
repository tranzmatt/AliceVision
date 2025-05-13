# src/cmake/dependencies/openexr.cmake

# Build configuration for OpenEXR

if(AV_BUILD_OPENEXR)
    set(OPENEXR_TARGET openexr)
    set(OPENEXR_VERSION "3.3.3")
    set(OPENEXR_HASH "MD5=1748da38ffd037f6cc32347b2f40aa0e")
    
    # Check if this dependency needs to be rebuilt
    needs_rebuild(${OPENEXR_TARGET} ${AV_DEPS_VERSION} OPENEXR_NEEDS_REBUILD)
    
    if(OPENEXR_NEEDS_REBUILD)
        message(STATUS "Building OpenEXR ${OPENEXR_VERSION}")
        
        ExternalProject_Add(${OPENEXR_TARGET}
            URL https://github.com/AcademySoftwareFoundation/openexr/archive/v${OPENEXR_VERSION}.tar.gz
            URL_HASH ${OPENEXR_HASH}
            DOWNLOAD_DIR ${BUILD_DIR}/download/openexr
            PREFIX ${BUILD_DIR}
            BUILD_IN_SOURCE 0
            BUILD_ALWAYS 0
            UPDATE_COMMAND ""
            SOURCE_DIR ${CMAKE_CURRENT_BINARY_DIR}/openexr
            BINARY_DIR ${BUILD_DIR}/openexr_build
            INSTALL_DIR ${CMAKE_INSTALL_PREFIX}
            CONFIGURE_COMMAND ${CMAKE_COMMAND} ${CMAKE_CORE_BUILD_FLAGS} 
                    -DOPENEXR_BUILD_PYTHON_LIBS:BOOL=OFF 
                    -DBUILD_TESTING:BOOL=OFF 
                    -DOPENEXR_INSTALL_EXAMPLES:BOOL=OFF
                    -DOPENEXR_BUILD_TOOLS:BOOL=OFF
                    ${ZLIB_CMAKE_FLAGS} 
                    -DCMAKE_INSTALL_PREFIX=<INSTALL_DIR> 
		    -DCMAKE_POLICY_VERSION_MINIMUM=3.5
                    <SOURCE_DIR>
            BUILD_COMMAND VERBOSE=1 $(MAKE) -j${CPU_CORES}
            DEPENDS zlib
        )
        
        # Add a step to mark this dependency as built
        add_mark_built_step(${OPENEXR_TARGET} ${AV_DEPS_VERSION})
    else()
        message(STATUS "OpenEXR ${OPENEXR_VERSION} already built, skipping")
        
        # Create dummy target for dependency tracking
        add_custom_target(${OPENEXR_TARGET}
            COMMAND ${CMAKE_COMMAND} -E echo "OpenEXR already built, skipping."
        )
    endif()
    
    # Register this dependency
    register_dependency(${OPENEXR_TARGET})
    
    # Set flags for other dependencies that use OpenEXR
    set(ILMBASE_CMAKE_FLAGS 
        -DILMBASE_ROOT=${CMAKE_INSTALL_PREFIX} 
        -DILMBASE_INCLUDE_PATH=${CMAKE_INSTALL_PREFIX}/include/OpenEXR
    )
    
    set(OPENEXR_CMAKE_FLAGS 
        ${ILMBASE_CMAKE_FLAGS} 
        -DOPENEXR_ROOT=${CMAKE_INSTALL_PREFIX} 
        -DOPENEXR_INCLUDE_PATH=${CMAKE_INSTALL_PREFIX}/include
    )
endif()
