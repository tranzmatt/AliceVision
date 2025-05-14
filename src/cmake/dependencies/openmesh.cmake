# src/cmake/dependencies/openmesh.cmake

# Build configuration for OpenMesh

if(AV_BUILD_OPENMESH)
    set(OPENMESH_TARGET OpenMesh)
    set(OPENMESH_VERSION "10.0.0")
    set(OPENMESH_HASH "MD5=4d166aecbc09df58b38de9759c92a437")
    
    # Check if this dependency needs to be rebuilt
    needs_rebuild(${OPENMESH_TARGET} ${AV_DEPS_VERSION} OPENMESH_NEEDS_REBUILD)
    
    if(OPENMESH_NEEDS_REBUILD)
        message(STATUS "Building OpenMesh ${OPENMESH_VERSION}")
        
        ExternalProject_add(${OPENMESH_TARGET}
            URL https://www.graphics.rwth-aachen.de/media/openmesh_static/Releases/10.0/OpenMesh-${OPENMESH_VERSION}.tar.bz2
            URL_HASH ${OPENMESH_HASH}
            DOWNLOAD_DIR ${BUILD_DIR}/download/${OPENMESH_TARGET}
            DOWNLOAD_EXTRACT_TIMESTAMP TRUE
            PREFIX ${BUILD_DIR}
            BUILD_IN_SOURCE 0
            BUILD_ALWAYS 0
            UPDATE_COMMAND ""
            SOURCE_DIR ${CMAKE_CURRENT_BINARY_DIR}/${OPENMESH_TARGET}
            BINARY_DIR ${BUILD_DIR}/${OPENMESH_TARGET}_build
            INSTALL_DIR ${CMAKE_INSTALL_PREFIX}
            CONFIGURE_COMMAND ${CMAKE_COMMAND}
                -DCMAKE_BUILD_TYPE=Release
                -DCMAKE_POLICY_VERSION_MINIMUM=3.8
                -DCMAKE_INSTALL_PREFIX:PATH=<INSTALL_DIR> <SOURCE_DIR>
                -DBUILD_APPS=OFF
                -DOPENMESH_DOCS=OFF
            BUILD_COMMAND $(MAKE) -j${CPU_CORES}
        )
        
        # Add a step to mark this dependency as built
        add_mark_built_step(${OPENMESH_TARGET} ${AV_DEPS_VERSION})
    else()
        message(STATUS "OpenMesh ${OPENMESH_VERSION} already built, skipping")
        
        # Create dummy target for dependency tracking
        add_custom_target(${OPENMESH_TARGET}
            COMMAND ${CMAKE_COMMAND} -E echo "OpenMesh already built, skipping."
        )
    endif()
    
    # Register this dependency
    register_dependency(${OPENMESH_TARGET})
    
    # Set flags for other dependencies that use OpenMesh
    set(OPENMESH_CMAKE_FLAGS -DOPENMESH_DIR:PATH=${CMAKE_INSTALL_PREFIX}/share/OpenMesh/cmake)
endif()
