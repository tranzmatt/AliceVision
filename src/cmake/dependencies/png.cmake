# src/cmake/dependencies/png.cmake

# Build configuration for PNG

if(AV_BUILD_PNG)
    set(PNG_TARGET png)
    set(PNG_VERSION "1.6.39")
    set(PNG_HASH "MD5=93b8e79a008747e70f7704f600349559")
    
    # Check if this dependency needs to be rebuilt
    needs_rebuild(${PNG_TARGET} ${AV_DEPS_VERSION} PNG_NEEDS_REBUILD)
    
    if(PNG_NEEDS_REBUILD)
        message(STATUS "Building PNG ${PNG_VERSION}")
        
        # Check for ARM processors
        if(${CMAKE_SYSTEM_PROCESSOR} MATCHES "arm") 
            set(AV_PNG_ARM_NEON OFF)
        else()
            set(AV_PNG_ARM_NEON off)
        endif()

        ExternalProject_Add(${PNG_TARGET}
            URL https://download.sourceforge.net/libpng/libpng-${PNG_VERSION}.tar.gz
            URL_HASH ${PNG_HASH}
            DOWNLOAD_DIR ${BUILD_DIR}/download/libpng
            PREFIX ${BUILD_DIR}
            BUILD_IN_SOURCE 0
            BUILD_ALWAYS 0
            UPDATE_COMMAND ""
            SOURCE_DIR ${CMAKE_CURRENT_BINARY_DIR}/png
            BINARY_DIR ${BUILD_DIR}/png_build
            INSTALL_DIR ${CMAKE_INSTALL_PREFIX}
            CONFIGURE_COMMAND ${CMAKE_COMMAND} ${CMAKE_CORE_BUILD_FLAGS}
                ${ZLIB_CMAKE_FLAGS}
                -DPNG_ARM_NEON=${AV_PNG_ARM_NEON}
                -DCMAKE_INSTALL_PREFIX=<INSTALL_DIR>
                <SOURCE_DIR>
            BUILD_COMMAND $(MAKE) -j${CPU_CORES}
            DEPENDS zlib
        )
        
        # Add a step to mark this dependency as built
        add_mark_built_step(${PNG_TARGET} ${AV_DEPS_VERSION})
    else()
        message(STATUS "PNG ${PNG_VERSION} already built, skipping")
        
        # Create dummy target for dependency tracking
        add_custom_target(${PNG_TARGET}
            COMMAND ${CMAKE_COMMAND} -E echo "PNG already built, skipping."
        )
    endif()
    
    # Register this dependency
    register_dependency(${PNG_TARGET})
    
    # Set flags for other dependencies that use PNG
    set(PNG_CMAKE_FLAGS 
        -DPNG_LIBRARY=${CMAKE_INSTALL_PREFIX}/${CMAKE_INSTALL_LIBDIR}/libpng${CMAKE_SHARED_LIBRARY_SUFFIX} 
        -DPNG_INCLUDE_DIR=${CMAKE_INSTALL_PREFIX}/include
    )
endif()