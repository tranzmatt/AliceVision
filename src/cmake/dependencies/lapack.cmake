# src/cmake/dependencies/lapack.cmake

# Build configuration for LAPACK

if(AV_BUILD_LAPACK)
    set(LAPACK_TARGET lapack)
    set(LAPACK_VERSION "3.12.1")
    set(LAPACK_HASH "MD5=2f069617e16b42f5eddcfee85768f204")
    
    # Check if this dependency needs to be rebuilt
    needs_rebuild(${LAPACK_TARGET} ${AV_DEPS_VERSION} LAPACK_NEEDS_REBUILD)
    
    if(LAPACK_NEEDS_REBUILD)
        message(STATUS "Building LAPACK ${LAPACK_VERSION}")
        
        ExternalProject_Add(${LAPACK_TARGET}
            URL https://github.com/Reference-LAPACK/lapack/archive/v${LAPACK_VERSION}.tar.gz
            URL_HASH ${LAPACK_HASH}
            DOWNLOAD_DIR ${BUILD_DIR}/download/lapack
            PREFIX ${BUILD_DIR}
            BUILD_IN_SOURCE 0
            BUILD_ALWAYS 0
            UPDATE_COMMAND ""
            SOURCE_DIR ${CMAKE_CURRENT_BINARY_DIR}/lapack
            BINARY_DIR ${BUILD_DIR}/lapack_build
            INSTALL_DIR ${CMAKE_INSTALL_PREFIX}
            CONFIGURE_COMMAND ${CMAKE_COMMAND} ${CMAKE_CORE_BUILD_FLAGS}
                -DCMAKE_INSTALL_PREFIX:PATH=<INSTALL_DIR>
		-DCMAKE_POLICY_VERSION_MINIMUM=3.5
                <SOURCE_DIR>
            BUILD_COMMAND $(MAKE) -j${CPU_CORES}
            DEPENDS tbb
        )
        
        # Add a step to mark this dependency as built
        add_mark_built_step(${LAPACK_TARGET} ${AV_DEPS_VERSION})
    else()
        message(STATUS "LAPACK ${LAPACK_VERSION} already built, skipping")
        
        # Create dummy target for dependency tracking
        add_custom_target(${LAPACK_TARGET}
            COMMAND ${CMAKE_COMMAND} -E echo "LAPACK already built, skipping."
        )
    endif()
    
    # Register this dependency
    register_dependency(${LAPACK_TARGET})
    
    # Set flags for other dependencies that use LAPACK
    set(BLAS_LIBRARIES ${CMAKE_INSTALL_PREFIX}/${CMAKE_INSTALL_LIBDIR}/libblas${CMAKE_SHARED_LIBRARY_SUFFIX})
    set(LAPACK_LIBRARIES ${CMAKE_INSTALL_PREFIX}/${CMAKE_INSTALL_LIBDIR}/liblapack${CMAKE_SHARED_LIBRARY_SUFFIX})
    set(LAPACK_CMAKE_FLAGS -DBLAS_LIBRARIES=${BLAS_LIBRARIES} -DLAPACK_LIBRARIES=${LAPACK_LIBRARIES})
endif()
