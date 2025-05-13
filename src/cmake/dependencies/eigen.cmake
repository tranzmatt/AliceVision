# src/cmake/dependencies/eigen.cmake

# Build configuration for Eigen

if(AV_BUILD_EIGEN)
    set(EIGEN_TARGET eigen)
    set(EIGEN_VERSION "3.4.0")
    set(EIGEN_HASH "MD5=132dde48fe2b563211675626d29f1707")
    
    # Check if this dependency needs to be rebuilt
    needs_rebuild(${EIGEN_TARGET} ${AV_DEPS_VERSION} EIGEN_NEEDS_REBUILD)
    
    if(EIGEN_NEEDS_REBUILD)
        message(STATUS "Building Eigen ${EIGEN_VERSION}")
        
        ExternalProject_Add(${EIGEN_TARGET}
            URL https://gitlab.com/libeigen/eigen/-/archive/${EIGEN_VERSION}/eigen-${EIGEN_VERSION}.tar.bz2
            URL_HASH ${EIGEN_HASH}
            DOWNLOAD_DIR ${BUILD_DIR}/download/eigen
            PREFIX ${BUILD_DIR}
            BUILD_IN_SOURCE 0
            BUILD_ALWAYS 0
            UPDATE_COMMAND ""
            SOURCE_DIR ${CMAKE_CURRENT_BINARY_DIR}/eigen
            BINARY_DIR ${BUILD_DIR}/eigen_build
            INSTALL_DIR ${CMAKE_INSTALL_PREFIX}
            CONFIGURE_COMMAND ${CMAKE_COMMAND} 
                -DCMAKE_CXX_STANDARD=17
                ${EIGEN_CMAKE_ALIGNMENT_FLAGS}
                -DCMAKE_INSTALL_PREFIX:PATH=<INSTALL_DIR>
		-DCMAKE_POLICY_VERSION_MINIMUM=3.5
                <SOURCE_DIR>
            BUILD_COMMAND $(MAKE) -j${CPU_CORES}
        )
        
        # Add a step to mark this dependency as built
        add_mark_built_step(${EIGEN_TARGET} ${AV_DEPS_VERSION})
    else()
        message(STATUS "Eigen ${EIGEN_VERSION} already built, skipping")
        
        # Create dummy target for dependency tracking
        add_custom_target(${EIGEN_TARGET}
            COMMAND ${CMAKE_COMMAND} -E echo "Eigen already built, skipping."
        )
    endif()
    
    # Register this dependency
    register_dependency(${EIGEN_TARGET})
    
    # Set flags for other dependencies that use Eigen
    set(EIGEN_CMAKE_FLAGS
        ${EIGEN_CMAKE_ALIGNMENT_FLAGS}
        -DEigen3_DIR:PATH=${CMAKE_INSTALL_PREFIX}/share/eigen3/cmake
        -DEIGEN3_INCLUDE_DIR=${CMAKE_INSTALL_PREFIX}/include/eigen3
        -DEIGEN_INCLUDE_DIR=${CMAKE_INSTALL_PREFIX}/include/eigen3
        -DEigen_INCLUDE_DIR=${CMAKE_INSTALL_PREFIX}/include/eigen3
    )
endif()
