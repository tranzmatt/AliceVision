# src/cmake/dependencies/libraw.cmake

# Build configuration for LibRaw

if(AV_BUILD_LIBRAW)
    set(LIBRAW_TARGET libraw)
    set(LIBRAW_VERSION "0.21.4")
    
    # Check if this dependency needs to be rebuilt
    needs_rebuild(${LIBRAW_TARGET} ${AV_DEPS_VERSION} LIBRAW_NEEDS_REBUILD)
    
    if(LIBRAW_NEEDS_REBUILD)
        message(STATUS "Building LibRaw ${LIBRAW_VERSION}")
        
        # First, set up the CMake build system
        ExternalProject_Add(libraw_cmake
            GIT_REPOSITORY https://github.com/LibRaw/LibRaw-cmake
            GIT_TAG eb98e4325aef2ce85d2eb031c2ff18640ca616d3
            DOWNLOAD_EXTRACT_TIMESTAMP TRUE
            PREFIX ${BUILD_DIR}
            BUILD_IN_SOURCE 0
            BUILD_ALWAYS 0
            UPDATE_COMMAND ""
            SOURCE_DIR ${CMAKE_CURRENT_BINARY_DIR}/libraw_cmake
            BINARY_DIR ${BUILD_DIR}/libraw_build
            INSTALL_DIR ${CMAKE_INSTALL_PREFIX}
            CONFIGURE_COMMAND ""
            BUILD_COMMAND ""
            INSTALL_COMMAND ""
        )
        
        # Then, build LibRaw using the CMake build system
        ExternalProject_Add(${LIBRAW_TARGET}
            GIT_REPOSITORY https://github.com/LibRaw/LibRaw
            GIT_TAG ${LIBRAW_VERSION}
            DOWNLOAD_EXTRACT_TIMESTAMP TRUE
            PREFIX ${BUILD_DIR}
            BUILD_IN_SOURCE 0
            BUILD_ALWAYS 0
            UPDATE_COMMAND ""
            SOURCE_DIR ${CMAKE_CURRENT_BINARY_DIR}/libraw
            BINARY_DIR ${CMAKE_CURRENT_BINARY_DIR}/libraw
            INSTALL_DIR ${CMAKE_INSTALL_PREFIX}
            # Native libraw configure script doesn't work OFF centos 7 (autoconf 2.69)
            # CONFIGURE_COMMAND autoconf && ./configure --enable-jpeg --enable-openmp --disable-examples --prefix=<INSTALL_DIR>
            # Use cmake build system (not maintained by libraw devs)
            CONFIGURE_COMMAND 
                cp <SOURCE_DIR>_cmake/CMakeLists.txt . &&
                cp -rf <SOURCE_DIR>_cmake/cmake . &&
                ${CMAKE_COMMAND} ${CMAKE_CORE_BUILD_FLAGS}
                -DENABLE_OPENMP=${AV_USE_OPENMP}
                -DENABLE_LCMS=ON
                -DENABLE_EXAMPLES=OFF
                ${ZLIB_CMAKE_FLAGS}
                -DCMAKE_INSTALL_PREFIX:PATH=<INSTALL_DIR>
                -DCMAKE_POLICY_VERSION_MINIMUM=3.8
                -DINSTALL_CMAKE_MODULE_PATH:PATH=<INSTALL_DIR>/cmake
                <SOURCE_DIR>
            BUILD_COMMAND $(MAKE) -j${CPU_CORES}
            DEPENDS libraw_cmake zlib
        )
        
        # Add a step to mark this dependency as built
        add_mark_built_step(${LIBRAW_TARGET} ${AV_DEPS_VERSION})
    else()
        message(STATUS "LibRaw ${LIBRAW_VERSION} already built, skipping")
        
        # Create dummy targets for dependency tracking
        add_custom_target(${LIBRAW_TARGET}
            COMMAND ${CMAKE_COMMAND} -E echo "LibRaw already built, skipping."
        )
        
        add_custom_target(libraw_cmake
            COMMAND ${CMAKE_COMMAND} -E echo "LibRaw CMake already built, skipping."
        )
    endif()
    
    # Register these dependencies
    register_dependency(${LIBRAW_TARGET})
    register_dependency(libraw_cmake)
    
    # Set flags for other dependencies that use LibRaw
    set(LIBRAW_CMAKE_FLAGS 
        -DLIBRAW_PATH=${CMAKE_INSTALL_PREFIX} 
        -DPC_LIBRAW_INCLUDEDIR=${CMAKE_INSTALL_PREFIX}/include 
        -DPC_LIBRAW_LIBDIR=${CMAKE_INSTALL_PREFIX}/lib 
        -DPC_LIBRAW_R_LIBDIR=${CMAKE_INSTALL_PREFIX}/lib
    )
endif()
