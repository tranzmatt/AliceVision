# src/cmake/dependencies/geogram.cmake

# Build configuration for Geogram

if(AV_BUILD_GEOGRAM)
    set(GEOGRAM_TARGET geogram)
    set(GEOGRAM_VERSION "1.9.5")
    set(GEOGRAM_HASH "MD5=5fb7a0fbc04de78b573440449bff3144")
    
    # Check if this dependency needs to be rebuilt
    needs_rebuild(${GEOGRAM_TARGET} ${AV_DEPS_VERSION} GEOGRAM_NEEDS_REBUILD)
    
    if(GEOGRAM_NEEDS_REBUILD)
        message(STATUS "Building Geogram ${GEOGRAM_VERSION}")
        
        # Set platform-specific variables
        if(WIN32)
            set(VORPALINE_PLATFORM Win-vs-dynamic-generic)
        elseif(APPLE)
            set(VORPALINE_PLATFORM Darwin-clang-dynamic)
        elseif(UNIX)
            set(VORPALINE_PLATFORM Linux64-gcc-dynamic)
        endif()
        
        ExternalProject_Add(${GEOGRAM_TARGET}
            URL https://github.com/BrunoLevy/geogram/releases/download/v${GEOGRAM_VERSION}/geogram_${GEOGRAM_VERSION}.tar.gz
            URL_HASH ${GEOGRAM_HASH}
            DOWNLOAD_DIR ${BUILD_DIR}/download/geogram
            DOWNLOAD_EXTRACT_TIMESTAMP TRUE
            PREFIX ${BUILD_DIR}
            BUILD_IN_SOURCE 0
            BUILD_ALWAYS 0
            UPDATE_COMMAND ""
            SOURCE_DIR ${CMAKE_CURRENT_BINARY_DIR}/geogram
            BINARY_DIR ${BUILD_DIR}/geogram_internal_build
            INSTALL_DIR ${CMAKE_INSTALL_PREFIX}
            CONFIGURE_COMMAND ${CMAKE_COMMAND} ${CMAKE_CORE_BUILD_FLAGS}
                ${ZLIB_CMAKE_FLAGS}
                -DVORPALINE_PLATFORM=${VORPALINE_PLATFORM}
                -DGEOGRAM_WITH_HLBFGS=OFF
                -DGEOGRAM_WITH_TETGEN=OFF
                -DGEOGRAM_WITH_GRAPHICS=OFF
                -DGEOGRAM_WITH_EXPLORAGRAM=OFF
                -DGEOGRAM_WITH_LUA=OFF
                -DCMAKE_INSTALL_PREFIX:PATH=<INSTALL_DIR>
                -DCMAKE_POLICY_VERSION_MINIMUM=3.8
                <SOURCE_DIR>
            BUILD_COMMAND $(MAKE) -j${CPU_CORES}
            DEPENDS zlib
        )
        
        # Add a step to mark this dependency as built
        add_mark_built_step(${GEOGRAM_TARGET} ${AV_DEPS_VERSION})
    else()
        message(STATUS "Geogram ${GEOGRAM_VERSION} already built, skipping")
        
        # Create dummy target for dependency tracking
        add_custom_target(${GEOGRAM_TARGET}
            COMMAND ${CMAKE_COMMAND} -E echo "Geogram already built, skipping."
        )
    endif()
    
    # Register this dependency
    register_dependency(${GEOGRAM_TARGET})
    
    # Set flags for dependencies that use Geogram
    set(GEOGRAM_CMAKE_FLAGS 
        -DGEOGRAM_INSTALL_PREFIX=${CMAKE_INSTALL_PREFIX} 
        -DGEOGRAM_INCLUDE_DIR=${CMAKE_INSTALL_PREFIX}/include/geogram1
    )
endif()
