# src/cmake/dependencies/alembic.cmake

# Build configuration for Alembic

if(AV_BUILD_ALEMBIC)
    set(ALEMBIC_TARGET alembic)
    set(ALEMBIC_VERSION "1.8.5")
    set(ALEMBIC_HASH "MD5=fcd5b5492a005057e11b601b60ac9a49")
    
    # Check if this dependency needs to be rebuilt
    needs_rebuild(${ALEMBIC_TARGET} ${AV_DEPS_VERSION} ALEMBIC_NEEDS_REBUILD)
    
    if(ALEMBIC_NEEDS_REBUILD)
        message(STATUS "Building Alembic ${ALEMBIC_VERSION}")
        
        ExternalProject_Add(${ALEMBIC_TARGET}
            # vfxplatform CY2022 1.8.x
            URL https://github.com/alembic/alembic/archive/${ALEMBIC_VERSION}.tar.gz
            URL_HASH ${ALEMBIC_HASH}
            DOWNLOAD_DIR ${BUILD_DIR}/download/alembic
            PREFIX ${BUILD_DIR}
            BUILD_IN_SOURCE 0
            BUILD_ALWAYS 0
            UPDATE_COMMAND ""
            SOURCE_DIR ${CMAKE_CURRENT_BINARY_DIR}/alembic
            BINARY_DIR ${BUILD_DIR}/alembic_build
            INSTALL_DIR ${CMAKE_INSTALL_PREFIX}
            CONFIGURE_COMMAND 
                ${CMAKE_COMMAND} 
                ${CMAKE_CORE_BUILD_FLAGS}
                ${ZLIB_CMAKE_FLAGS}
                ${ILMBASE_CMAKE_FLAGS}
                -DUSE_TESTS=OFF
                -DCMAKE_INSTALL_PREFIX:PATH=<INSTALL_DIR>
                <SOURCE_DIR>
            BUILD_COMMAND $(MAKE) -j${CPU_CORES}
            DEPENDS boost openexr zlib
        )
        
        # Add a step to mark this dependency as built
        add_mark_built_step(${ALEMBIC_TARGET} ${AV_DEPS_VERSION})
    else()
        message(STATUS "Alembic ${ALEMBIC_VERSION} already built, skipping")
        
        # Create dummy target for dependency tracking
        add_custom_target(${ALEMBIC_TARGET}
            COMMAND ${CMAKE_COMMAND} -E echo "Alembic already built, skipping."
        )
    endif()
    
    # Register this dependency
    register_dependency(${ALEMBIC_TARGET})
    
    # Set flags for other dependencies that use Alembic
    set(ALEMBIC_CMAKE_FLAGS -DAlembic_DIR:PATH=${CMAKE_INSTALL_PREFIX}/lib/cmake/Alembic)
endif()