# src/cmake/dependencies/osi.cmake

# Build configuration for Open Solver Interface (Osi)

if(AV_BUILD_OSI)
    set(OSI_TARGET osi)
    set(OSI_COMMIT "52bafbabf8d29bcfd57818f0dd50ee226e01db7f") # Git commit hash
    
    # Check if this dependency needs to be rebuilt
    needs_rebuild(${OSI_TARGET} ${AV_DEPS_VERSION} OSI_NEEDS_REBUILD)
    
    if(OSI_NEEDS_REBUILD)
        message(STATUS "Building Osi ${OSI_COMMIT}")
        
        ExternalProject_Add(${OSI_TARGET}
            GIT_REPOSITORY https://github.com/alicevision/Osi
            GIT_TAG ${OSI_COMMIT}
            PREFIX ${BUILD_DIR}
            BUILD_IN_SOURCE 0
            BUILD_ALWAYS 0
            UPDATE_COMMAND ""
            SOURCE_DIR ${CMAKE_CURRENT_BINARY_DIR}/osi
            BINARY_DIR ${BUILD_DIR}/osi_build
            INSTALL_DIR ${CMAKE_INSTALL_PREFIX}
            CONFIGURE_COMMAND 
                ${CMAKE_COMMAND} 
                ${CMAKE_CORE_BUILD_FLAGS}
                -DCMAKE_INSTALL_PREFIX:PATH=<INSTALL_DIR>
                <SOURCE_DIR>
            BUILD_COMMAND $(MAKE) -j${CPU_CORES}
            DEPENDS coinutils
        )
        
        # Add a step to mark this dependency as built
        add_mark_built_step(${OSI_TARGET} ${AV_DEPS_VERSION})
    else()
        message(STATUS "Osi ${OSI_COMMIT} already built, skipping")
        
        # Create dummy target for dependency tracking
        add_custom_target(${OSI_TARGET}
            COMMAND ${CMAKE_COMMAND} -E echo "Osi already built, skipping."
        )
    endif()
    
    # Register this dependency
    register_dependency(${OSI_TARGET})
    
    # Set flags for other dependencies that use Osi
    set(OSI_CMAKE_FLAGS -DOsi_DIR:PATH=${CMAKE_INSTALL_PREFIX}/share/osi)
endif()