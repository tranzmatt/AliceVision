# src/cmake/dependencies/suitesparse.cmake

# Build configuration for SuiteSparse

if(AV_BUILD_SUITESPARSE)
    set(SUITESPARSE_TARGET suitesparse)
    set(SUITESPARSE_VERSION "7.3.0")
    set(SUITESPARSE_HASH "MD5=6ff86003a85d73eb383d82db04af7373")
    
    # Check if this dependency needs to be rebuilt
    needs_rebuild(${SUITESPARSE_TARGET} ${AV_DEPS_VERSION} SUITESPARSE_NEEDS_REBUILD)
    
    if(SUITESPARSE_NEEDS_REBUILD)
        message(STATUS "Building SuiteSparse ${SUITESPARSE_VERSION}")
        
        # Dependencies: GMP and MPFR
        set(GMP_TARGET gmp)
        set(GMP_VERSION "6.2.1")
        set(GMP_HASH "MD5=0b82665c4a92fd2ade7440c13fcaa42b")

        needs_rebuild(${GMP_TARGET} ${AV_DEPS_VERSION} GMP_NEEDS_REBUILD)
        
        if(GMP_NEEDS_REBUILD)
            message(STATUS "Building GMP ${GMP_VERSION} for SuiteSparse")
            
            ExternalProject_add(${GMP_TARGET}
                URL https://gmplib.org/download/gmp/gmp-${GMP_VERSION}.tar.xz
                URL_HASH ${GMP_HASH}
                DOWNLOAD_DIR ${BUILD_DIR}/download/gmp
                PREFIX ${BUILD_DIR}
                BUILD_IN_SOURCE 0
                BUILD_ALWAYS 0
                UPDATE_COMMAND ""
                INSTALL_DIR ${CMAKE_INSTALL_PREFIX}
                CONFIGURE_COMMAND <SOURCE_DIR>/configure --prefix=<INSTALL_DIR> --enable-cxx
                BUILD_COMMAND $(MAKE) -j${CPU_CORES}
            )
            
            add_mark_built_step(${GMP_TARGET} ${AV_DEPS_VERSION})
        else()
            message(STATUS "GMP ${GMP_VERSION} already built, skipping")
            
            add_custom_target(${GMP_TARGET}
                COMMAND ${CMAKE_COMMAND} -E echo "GMP already built, skipping."
            )
        endif()
        
        set(MPFR_TARGET mpfr)
        set(MPFR_VERSION "4.2.0")
        set(MPFR_HASH "MD5=279b527503118a22bd0022e0d64807cb")

        needs_rebuild(${MPFR_TARGET} ${AV_DEPS_VERSION} MPFR_NEEDS_REBUILD)
        
        if(MPFR_NEEDS_REBUILD)
            message(STATUS "Building MPFR ${MPFR_VERSION} for SuiteSparse")
            
            ExternalProject_add(${MPFR_TARGET}
                URL https://ftp.gnu.org/gnu/mpfr/mpfr-${MPFR_VERSION}.tar.gz
                URL_HASH ${MPFR_HASH}
                DOWNLOAD_DIR ${BUILD_DIR}/download/mpfr
                PREFIX ${BUILD_DIR}
                BUILD_IN_SOURCE 0
                BUILD_ALWAYS 0
                UPDATE_COMMAND ""
                INSTALL_DIR ${CMAKE_INSTALL_PREFIX}
                CONFIGURE_COMMAND <SOURCE_DIR>/configure --prefix=<INSTALL_DIR> --with-gmp=<INSTALL_DIR>
                BUILD_COMMAND $(MAKE) -j${CPU_CORES}
                DEPENDS ${GMP_TARGET}
            )
            
            add_mark_built_step(${MPFR_TARGET} ${AV_DEPS_VERSION})
        else()
            message(STATUS "MPFR ${MPFR_VERSION} already built, skipping")
            
            add_custom_target(${MPFR_TARGET}
                COMMAND ${CMAKE_COMMAND} -E echo "MPFR already built, skipping."
            )
        endif()
        
        # Platform-specific make commands
        if(APPLE)
            set(SUITESPARSE_INTERNAL_MAKE_CMD VERBOSE=1 MPFR_ROOT=${CMAKE_INSTALL_PREFIX} GMP_ROOT=${CMAKE_INSTALL_PREFIX} DYLD_LIBRARY_PATH=${DYLD_LIBRARY_PATH}:${CMAKE_INSTALL_PREFIX}/${CMAKE_INSTALL_LIBDIR} $(MAKE) -j${CPU_CORES} BLAS="${BLAS_LIBRARIES}" LAPACK="${LAPACK_LIBRARIES}" LAPACK_LIBRARIES="${LAPACK_LIBRARIES}")
        else()
            set(SUITESPARSE_INTERNAL_MAKE_CMD VERBOSE=1 MPFR_ROOT=${CMAKE_INSTALL_PREFIX} GMP_ROOT=${CMAKE_INSTALL_PREFIX} LD_LIBRARY_PATH=${LD_LIBRARY_PATH}:${CMAKE_INSTALL_PREFIX}/${CMAKE_INSTALL_LIBDIR} $(MAKE) -j${CPU_CORES} BLAS_LIBRARIES="${BLAS_LIBRARIES}" BLAS="${BLAS_LIBRARIES}" LAPACK="${LAPACK_LIBRARIES}" LAPACK_LIBRARIES="${LAPACK_LIBRARIES}")
        endif()
        
        # Main SuiteSparse build
        ExternalProject_Add(${SUITESPARSE_TARGET}
            URL https://github.com/DrTimothyAldenDavis/SuiteSparse/archive/v${SUITESPARSE_VERSION}.tar.gz
            URL_HASH ${SUITESPARSE_HASH}
            DOWNLOAD_DIR ${BUILD_DIR}/download/suitesparse
            PREFIX ${BUILD_DIR}
            BUILD_IN_SOURCE 0
            BUILD_ALWAYS 0
            UPDATE_COMMAND ""
            SOURCE_DIR ${CMAKE_CURRENT_BINARY_DIR}/suitesparse
            BINARY_DIR ${CMAKE_CURRENT_BINARY_DIR}/suitesparse
            INSTALL_DIR ${CMAKE_INSTALL_PREFIX}
            CONFIGURE_COMMAND ""
            BUILD_COMMAND   cd <BINARY_DIR> && ${SUITESPARSE_INTERNAL_MAKE_CMD} library CC=${CMAKE_C_COMPILER} CXX=${CMAKE_CXX_COMPILER} CMAKE_OPTIONS=-DBLAS_LIBRARIES=${BLAS_LIBRARIES}\ -DLAPACK_LIBRARIES=${LAPACK_LIBRARIES}\ -DCMAKE_INSTALL_PREFIX=<INSTALL_DIR>
            INSTALL_COMMAND cd <BINARY_DIR> && ${SUITESPARSE_INTERNAL_MAKE_CMD} install library INSTALL=<INSTALL_DIR> CC=${CMAKE_C_COMPILER} CXX=${CMAKE_CXX_COMPILER} CMAKE_OPTIONS=-DCMAKE_INSTALL_PREFIX=<INSTALL_DIR>
            DEPENDS ${LAPACK_TARGET} ${MPFR_TARGET}
        )
        
        # Add a step to mark this dependency as built
        add_mark_built_step(${SUITESPARSE_TARGET} ${AV_DEPS_VERSION})
    else()
        message(STATUS "SuiteSparse ${SUITESPARSE_VERSION} already built, skipping")
        
        # Create dummy targets for dependency tracking
        add_custom_target(${SUITESPARSE_TARGET}
            COMMAND ${CMAKE_COMMAND} -E echo "SuiteSparse already built, skipping."
        )
        
        add_custom_target(gmp
            COMMAND ${CMAKE_COMMAND} -E echo "GMP already built, skipping."
        )
        
        add_custom_target(mpfr
            COMMAND ${CMAKE_COMMAND} -E echo "MPFR already built, skipping."
        )
    endif()
    
    # Register dependencies
    register_dependency(${SUITESPARSE_TARGET})
    register_dependency(gmp)
    register_dependency(mpfr)
    
    # Set flags for other dependencies that use SuiteSparse
    set(SUITESPARSE_CMAKE_FLAGS ${LAPACK_CMAKE_FLAGS} -DSUITESPARSE_INCLUDE_DIR_HINTS=${CMAKE_INSTALL_PREFIX}/include -DSUITESPARSE_LIBRARY_DIR_HINTS=${CMAKE_INSTALL_PREFIX}/lib)
endif()