# src/cmake/dependencies/flann.cmake

# Build configuration for FLANN (Fast Library for Approximate Nearest Neighbors)

if(AV_BUILD_FLANN)
    set(FLANN_TARGET flann)
    set(FLANN_VERSION "f9caaf609d8b8cb2b7104a85cf59eb92c275a25d") # Git commit hash
    
    # Check if FLANN needs to be rebuilt
    needs_rebuild(${FLANN_TARGET} ${AV_DEPS_VERSION} FLANN_NEEDS_REBUILD)
    
    if(FLANN_NEEDS_REBUILD)
        message(STATUS "Building FLANN ${FLANN_VERSION}")
        
        # First build LZ4 dependency
        set(LZ4_TARGET lz4)
        set(LZ4_VERSION "1.10.0")
        
        needs_rebuild(${LZ4_TARGET} ${AV_DEPS_VERSION} LZ4_NEEDS_REBUILD)
        
        if(LZ4_NEEDS_REBUILD)
            message(STATUS "Building LZ4 ${LZ4_VERSION} for FLANN")
            
            ExternalProject_Add(${LZ4_TARGET}
                GIT_REPOSITORY https://github.com/lz4/lz4
                GIT_TAG v${LZ4_VERSION}
                PREFIX ${BUILD_DIR}
                BUILD_IN_SOURCE 0
                BUILD_ALWAYS 0
                UPDATE_COMMAND ""
                SOURCE_DIR ${CMAKE_CURRENT_BINARY_DIR}/${LZ4_TARGET}
                BINARY_DIR ${BUILD_DIR}/${LZ4_TARGET}_build
                INSTALL_DIR ${CMAKE_INSTALL_PREFIX}
                CONFIGURE_COMMAND ${CMAKE_COMMAND} 
                    ${CMAKE_CORE_BUILD_FLAGS}
                    -DCMAKE_INSTALL_PREFIX:PATH=<INSTALL_DIR>
		    -DCMAKE_POLICY_VERSION_MINIMUM=3.5
                    <SOURCE_DIR>/build/cmake/
                BUILD_COMMAND $(MAKE) -j${CPU_CORES}
                INSTALL_COMMAND $(MAKE) -j${CPU_CORES} install 
            )
            
            add_mark_built_step(${LZ4_TARGET} ${AV_DEPS_VERSION})
        else()
            message(STATUS "LZ4 ${LZ4_VERSION} already built, skipping")
            
            # Create dummy target
            add_custom_target(${LZ4_TARGET}
                COMMAND ${CMAKE_COMMAND} -E echo "LZ4 already built, skipping."
            )
        endif()
        
        set(LZ4_CMAKE_FLAGS -Dlz4_DIR:PATH=${CMAKE_INSTALL_PREFIX}/lib/cmake/lz4/)
        
        # Now build FLANN itself
        ExternalProject_Add(${FLANN_TARGET}
            GIT_REPOSITORY https://github.com/flann-lib/flann
            GIT_TAG ${FLANN_VERSION}
            PREFIX ${BUILD_DIR}
            BUILD_IN_SOURCE 0
            BUILD_ALWAYS 0
            UPDATE_COMMAND ""
            SOURCE_DIR ${CMAKE_CURRENT_BINARY_DIR}/${FLANN_TARGET}
            BINARY_DIR ${BUILD_DIR}/${FLANN_TARGET}_build
            INSTALL_DIR ${CMAKE_INSTALL_PREFIX}
            CONFIGURE_COMMAND 
                ${CMAKE_COMMAND} -E env PKG_CONFIG_PATH=${CMAKE_INSTALL_PREFIX}/lib64/pkgconfig/
                ${CMAKE_COMMAND} 
                ${CMAKE_CORE_BUILD_FLAGS}
                -DBUILD_C_BINDINGS:BOOL=OFF
                -DBUILD_EXAMPLES=OFF
                -DBUILD_TESTS:BOOL=OFF
                -DBUILD_DOC:BOOL=OFF
                -DBUILD_PYTHON_BINDINGS:BOOL=OFF
                -DBUILD_MATLAB_BINDINGS:BOOL=OFF
                -DCMAKE_INSTALL_PREFIX:PATH=<INSTALL_DIR> <SOURCE_DIR>
            BUILD_COMMAND $(MAKE) -j${CPU_CORES}
            INSTALL_COMMAND $(MAKE) -j${CPU_CORES} install
            DEPENDS ${LZ4_TARGET}
        )
        
        add_mark_built_step(${FLANN_TARGET} ${AV_DEPS_VERSION})
    else()
        message(STATUS "FLANN ${FLANN_VERSION} already built, skipping")
        
        # Create dummy target
        add_custom_target(${FLANN_TARGET}
            COMMAND ${CMAKE_COMMAND} -E echo "FLANN already built, skipping."
        )
        
        # Check if LZ4 dependency exists too
        if(EXISTS "${BUILD_DIR}/lz4_built.stamp")
            add_custom_target(lz4
                COMMAND ${CMAKE_COMMAND} -E echo "LZ4 already built, skipping."
            )
        endif()
    endif()
    
    # Register dependencies
    register_dependency(${FLANN_TARGET})
    register_dependency(${LZ4_TARGET})
    
    # Set flags for dependencies that use FLANN
    set(FLANN_CMAKE_FLAGS -Dflann_DIR:PATH=${CMAKE_INSTALL_PREFIX}/lib/cmake/flann/)
endif()
