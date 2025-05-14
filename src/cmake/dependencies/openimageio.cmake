# src/cmake/dependencies/openimageio.cmake

# Build configuration for OpenImageIO

if(AV_BUILD_OPENIMAGEIO)
    set(OPENIMAGEIO_TARGET openimageio)
    set(OPENIMAGEIO_VERSION "2.5.8.0")
    set(OPENIMAGEIO_HASH "MD5=1da1065711ad29fb123d2f21a12f72cc")
    
    # Check if this dependency needs to be rebuilt
    needs_rebuild(${OPENIMAGEIO_TARGET} ${AV_DEPS_VERSION} OPENIMAGEIO_NEEDS_REBUILD)
    
    if(OPENIMAGEIO_NEEDS_REBUILD)
        message(STATUS "Building OpenImageIO ${OPENIMAGEIO_VERSION}")
        
        ExternalProject_Add(${OPENIMAGEIO_TARGET}
            URL https://github.com/AcademySoftwareFoundation/OpenImageIO/archive/refs/tags/v${OPENIMAGEIO_VERSION}.tar.gz
            URL_HASH ${OPENIMAGEIO_HASH}
            DOWNLOAD_DIR ${BUILD_DIR}/download/oiio
            DOWNLOAD_EXTRACT_TIMESTAMP TRUE
            PREFIX ${BUILD_DIR}
            BUILD_IN_SOURCE 0
            BUILD_ALWAYS 0
            UPDATE_COMMAND ""
            SOURCE_DIR ${CMAKE_CURRENT_BINARY_DIR}/openimageio
            BINARY_DIR ${BUILD_DIR}/openimageio_build
            INSTALL_DIR ${CMAKE_INSTALL_PREFIX}
            CONFIGURE_COMMAND 
                ${CMAKE_COMMAND} 
                ${CMAKE_CORE_BUILD_FLAGS}
                -DCMAKE_PREFIX_PATH=${CMAKE_INSTALL_PREFIX}
                -DCMAKE_POLICY_VERSION_MINIMUM=3.8
                -DBOOST_ROOT=${CMAKE_INSTALL_PREFIX}
                -DOIIO_BUILD_TESTS:BOOL=OFF
                -DOIIO_BUILD_TOOLS:BOOL=OFF
                -DILMBASE_HOME=${CMAKE_INSTALL_PREFIX}
                -DOPENEXR_HOME=${CMAKE_INSTALL_PREFIX}
                ${TIFF_CMAKE_FLAGS} ${ZLIB_CMAKE_FLAGS} ${PNG_CMAKE_FLAGS} ${JPEG_CMAKE_FLAGS} ${LIBRAW_CMAKE_FLAGS} ${OPENEXR_CMAKE_FLAGS}
                -DCMAKE_INSTALL_PREFIX:PATH=<INSTALL_DIR> <SOURCE_DIR>
                -DSTOP_ON_WARNING=OFF
                -DUSE_FFMPEG=${AV_BUILD_FFMPEG}
                -DUSE_TURBOJPEG=${AV_BUILD_JPEG}
                -DUSE_LIBRAW=${AV_BUILD_LIBRAW}
                -DUSE_OPENEXR=${AV_BUILD_OPENEXR}
                -DUSE_TIFF=${AV_BUILD_TIFF}
                -DUSE_PNG=${AV_BUILD_PNG}
                -DUSE_PYTHON=OFF -DUSE_OPENCV=OFF -DUSE_OPENGL=OFF -DUSE_NUKE=OFF -DUSE_PTEX=OFF -DBUILD_DOCS=OFF -DBUILD_TESTING=OFF
                # TODO: build with libheif
            BUILD_COMMAND $(MAKE) -j${CPU_CORES}
            DEPENDS boost openexr tiff png turbojpeg libraw zlib ffmpeg
        )
        
        # Add a step to mark this dependency as built
        add_mark_built_step(${OPENIMAGEIO_TARGET} ${AV_DEPS_VERSION})
    else()
        message(STATUS "OpenImageIO ${OPENIMAGEIO_VERSION} already built, skipping")
        
        # Create dummy target for dependency tracking
        add_custom_target(${OPENIMAGEIO_TARGET}
            COMMAND ${CMAKE_COMMAND} -E echo "OpenImageIO already built, skipping."
        )
    endif()
    
    # Register this dependency
    register_dependency(${OPENIMAGEIO_TARGET})
    
    # Set flags for other dependencies that use OpenImageIO
    set(OPENIMAGEIO_CMAKE_FLAGS -DOpenImageIO_DIR=${CMAKE_INSTALL_PREFIX})
endif()
