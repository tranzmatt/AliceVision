# src/cmake/dependencies/ceres.cmake

# Build configuration for Ceres Solver

if(AV_BUILD_CERES)
    set(CERES_TARGET ceres)
    set(CERES_VERSION "2.2.0")
    
    # Check if this dependency needs to be rebuilt
    needs_rebuild(${CERES_TARGET} ${AV_DEPS_VERSION} CERES_NEEDS_REBUILD)
    
    if(CERES_NEEDS_REBUILD)
        message(STATUS "Building Ceres ${CERES_VERSION}")
        
        ExternalProject_Add(${CERES_TARGET}
            GIT_REPOSITORY https://github.com/ceres-solver/ceres-solver
            GIT_TAG ${CERES_VERSION}
            PREFIX ${BUILD_DIR}
            DOWNLOAD_EXTRACT_TIMESTAMP TRUE
            BUILD_IN_SOURCE 0
            BUILD_ALWAYS 0
            UPDATE_COMMAND ""
            SOURCE_DIR ${CMAKE_CURRENT_BINARY_DIR}/ceres-solver
            BINARY_DIR ${BUILD_DIR}/ceres_build
            INSTALL_DIR ${CMAKE_INSTALL_PREFIX}
            CONFIGURE_COMMAND 
                ${CMAKE_COMMAND} 
                ${CMAKE_CORE_BUILD_FLAGS}
                ${SUITESPARSE_CMAKE_FLAGS}
                -DSUITESPARSE:BOOL=ON
                -DLAPACK:BOOL=ON
                ${EIGEN_CMAKE_FLAGS}
                -DMINIGLOG=ON
                -DBUILD_EXAMPLES:BOOL=OFF
                -DCMAKE_INSTALL_PREFIX:PATH=<INSTALL_DIR>
                -DCMAKE_POLICY_VERSION_MINIMUM=3.8
                <SOURCE_DIR>
            BUILD_COMMAND $(MAKE) -j${CPU_CORES}
            DEPENDS eigen suitesparse
        )
        
        # Add a step to mark this dependency as built
        add_mark_built_step(${CERES_TARGET} ${AV_DEPS_VERSION})
    else()
        message(STATUS "Ceres ${CERES_VERSION} already built, skipping")
        
        # Create dummy target for dependency tracking
        add_custom_target(${CERES_TARGET}
            COMMAND ${CMAKE_COMMAND} -E echo "Ceres already built, skipping."
        )
    endif()
    
    # Register this dependency
    register_dependency(${CERES_TARGET})
    
    # Set flags for other dependencies that use Ceres
    set(CERES_CMAKE_FLAGS ${SUITESPARSE_CMAKE_FLAGS} -DCeres_DIR=${CMAKE_INSTALL_PREFIX}/${CMAKE_INSTALL_LIBDIR}/cmake/Ceres)
endif()
