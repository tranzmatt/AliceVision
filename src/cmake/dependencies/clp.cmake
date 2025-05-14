# src/cmake/dependencies/clp.cmake

# Build configuration for COIN-OR Linear Programming (Clp)

if(AV_BUILD_CLP)
    set(CLP_TARGET clp)
    set(CLP_COMMIT "4da587acebc65343faafea8a134c9f251efab5b9") # Git commit hash
    
    # Check if this dependency needs to be rebuilt
    needs_rebuild(${CLP_TARGET} ${AV_DEPS_VERSION} CLP_NEEDS_REBUILD)
    
    if(CLP_NEEDS_REBUILD)
        message(STATUS "Building Clp ${CLP_COMMIT}")
        
        ExternalProject_Add(${CLP_TARGET}
            GIT_REPOSITORY https://github.com/alicevision/Clp
            GIT_TAG ${CLP_COMMIT}
            PREFIX ${BUILD_DIR}
            DOWNLOAD_EXTRACT_TIMESTAMP TRUE
            BUILD_IN_SOURCE 0
            BUILD_ALWAYS 0
            UPDATE_COMMAND ""
            SOURCE_DIR ${CMAKE_CURRENT_BINARY_DIR}/clp
            BINARY_DIR ${BUILD_DIR}/clp_build
            INSTALL_DIR ${CMAKE_INSTALL_PREFIX}
            CONFIGURE_COMMAND 
                ${CMAKE_COMMAND} 
                ${CMAKE_CORE_BUILD_FLAGS}
                -DCMAKE_INSTALL_PREFIX:PATH=<INSTALL_DIR>
                -DCMAKE_POLICY_VERSION_MINIMUM=3.8
                <SOURCE_DIR>
            BUILD_COMMAND $(MAKE) -j${CPU_CORES}
            DEPENDS coinutils osi
        )
        
        # Add a step to mark this dependency as built
        add_mark_built_step(${CLP_TARGET} ${AV_DEPS_VERSION})
    else()
        message(STATUS "Clp ${CLP_COMMIT} already built, skipping")
        
        # Create dummy target for dependency tracking
        add_custom_target(${CLP_TARGET}
            COMMAND ${CMAKE_COMMAND} -E echo "Clp already built, skipping."
        )
    endif()
    
    # Register this dependency
    register_dependency(${CLP_TARGET})
    
    # Set flags for other dependencies that use Clp
    set(CLP_CMAKE_FLAGS -DClp_DIR:PATH=${CMAKE_INSTALL_PREFIX}/share/clp)
endif()
