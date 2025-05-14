# src/cmake/dependencies/assimp.cmake

# Build configuration for Assimp

if(AV_BUILD_ASSIMP)
    set(ASSIMP_TARGET assimp)
    set(ASSIMP_VERSION "5.2.5")
    set(ASSIMP_HASH "MD5=0b5a5a2714f1126b9931cdb95f512c91")
    
    # Check if this dependency needs to be rebuilt
    needs_rebuild(${ASSIMP_TARGET} ${AV_DEPS_VERSION} ASSIMP_NEEDS_REBUILD)
    
    if(ASSIMP_NEEDS_REBUILD)
        message(STATUS "Building Assimp ${ASSIMP_VERSION}")
        
        set(ASSIMP_BUILD_OPTIONS 
            -DASSIMP_BUILD_ASSIMP_TOOLS:BOOL=OFF 
            -DASSIMP_BUILD_TESTS:BOOL=OFF 
            -DASSIMP_BUILD_DRACO:BOOL=ON
        )
        
        ExternalProject_Add(${ASSIMP_TARGET}
            URL https://github.com/assimp/assimp/archive/refs/tags/v${ASSIMP_VERSION}.tar.gz
            URL_HASH ${ASSIMP_HASH}
            DOWNLOAD_DIR ${BUILD_DIR}/download/assimp
            DOWNLOAD_EXTRACT_TIMESTAMP TRUE
            PREFIX ${BUILD_DIR}
            BUILD_IN_SOURCE 0
            BUILD_ALWAYS 0
            SOURCE_DIR ${CMAKE_CURRENT_BINARY_DIR}/assimp
            BINARY_DIR ${BUILD_DIR}/assimp_build
            INSTALL_DIR ${CMAKE_INSTALL_PREFIX}
            CONFIGURE_COMMAND ${CMAKE_COMMAND} ${CMAKE_CORE_BUILD_FLAGS}
                ${ASSIMP_BUILD_OPTIONS}
                ${ZLIB_CMAKE_FLAGS}
                -DCMAKE_INSTALL_PREFIX:PATH=<INSTALL_DIR>
                -DCMAKE_POLICY_VERSION_MINIMUM=3.8
                -DASSIMP_WARNINGS_AS_ERRORS=OFF
                -DASSIMP_BUILD_TESTS=OFF
                <SOURCE_DIR>
            BUILD_COMMAND $(MAKE) -j${CPU_CORES}
            DEPENDS zlib
        )
        
        # Add a step to mark this dependency as built
        add_mark_built_step(${ASSIMP_TARGET} ${AV_DEPS_VERSION})
    else()
        message(STATUS "Assimp ${ASSIMP_VERSION} already built, skipping")
        
        # Create dummy target for dependency tracking
        add_custom_target(${ASSIMP_TARGET}
            COMMAND ${CMAKE_COMMAND} -E echo "Assimp already built, skipping."
        )
    endif()
    
    # Register this dependency
    register_dependency(${ASSIMP_TARGET})
    
    # Set flags for other dependencies that use Assimp
    set(ASSIMP_CMAKE_FLAGS 
        -DAssimp_DIR:PATH=${CMAKE_INSTALL_PREFIX}/lib/cmake/assimp-${ASSIMP_VERSION}
    )
endif()
