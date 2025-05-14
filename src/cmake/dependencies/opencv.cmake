# src/cmake/dependencies/opencv.cmake

# Build configuration for OpenCV

if(AV_BUILD_OPENCV)
    set(OPENCV_TARGET opencv)
    set(OPENCV_VERSION "4.11.0")
    set(OPENCV_HASH "MD5=f35fbd46350cc677af13e198805b58f7")
    set(OPENCV_CONTRIB_HASH "MD5=7dd4bc67eb67faff96ce71745a5e3abe")
    
    # Check if this dependency needs to be rebuilt
    needs_rebuild(${OPENCV_TARGET} ${AV_DEPS_VERSION} OPENCV_NEEDS_REBUILD)
    
    if(OPENCV_NEEDS_REBUILD)
        message(STATUS "Building OpenCV ${OPENCV_VERSION}")
        
        # First get OpenCV contrib modules
        ExternalProject_Add(opencv_contrib
            URL https://github.com/opencv/opencv_contrib/archive/refs/tags/${OPENCV_VERSION}.tar.gz
            URL_HASH ${OPENCV_CONTRIB_HASH}
            DOWNLOAD_DIR ${BUILD_DIR}/download/opencv_contrib
            DOWNLOAD_EXTRACT_TIMESTAMP TRUE
            SOURCE_DIR ${CMAKE_CURRENT_BINARY_DIR}/opencv_contrib
            BUILD_ALWAYS 0
            UPDATE_COMMAND ""
            CONFIGURE_COMMAND ""
            BUILD_COMMAND ""
            INSTALL_COMMAND ""
        )
        
        # Now build OpenCV
        ExternalProject_Add(${OPENCV_TARGET}
            URL https://github.com/opencv/opencv/archive/refs/tags/${OPENCV_VERSION}.tar.gz
            URL_HASH ${OPENCV_HASH}
            DOWNLOAD_DIR ${BUILD_DIR}/download/opencv
            DOWNLOAD_EXTRACT_TIMESTAMP TRUE
            UPDATE_COMMAND ""
            BUILD_IN_SOURCE 0
            BUILD_ALWAYS 0
            SOURCE_DIR ${CMAKE_CURRENT_BINARY_DIR}/opencv
            BINARY_DIR ${BUILD_DIR}/opencv_build
            INSTALL_DIR ${CMAKE_INSTALL_PREFIX}
            CONFIGURE_COMMAND 
                ${CMAKE_COMMAND} 
                ${CMAKE_CORE_BUILD_FLAGS}
                -DOPENCV_EXTRA_MODULES_PATH=${CMAKE_CURRENT_BINARY_DIR}/opencv_contrib/modules
                ${ZLIB_CMAKE_FLAGS} ${TBB_CMAKE_FLAGS} ${FFMPEG_CMAKE_FLAGS}
                ${TIFF_CMAKE_FLAGS} ${PNG_CMAKE_FLAGS} ${JPEG_CMAKE_FLAGS} ${LIBRAW_CMAKE_FLAGS}
                -DWITH_TBB=ON
                -DWITH_FFMPEG=${AV_BUILD_FFMPEG}
                -DBUILD_opencv_python2=OFF
                -DBUILD_opencv_python3=OFF
                -DWITH_GTK_2_X=OFF
                -DWITH_V4L=OFF
                -DINSTALL_C_EXAMPLES=OFF
                -DINSTALL_PYTHON_EXAMPLES=OFF
                -DBUILD_EXAMPLES=OFF
                -DWITH_QT=OFF
                -DWITH_OPENGL=OFF
                -DWITH_VTK=OFF
                -DWITH_OPENEXR=OFF  # Build error OFF IlmBase includes without "OpenEXR/" prefix
                -DENABLE_PRECOMPILED_HEADERS=OFF
                -DBUILD_SHARED_LIBS=ON
                -DWITH_CUDA=OFF
                -DWITH_OPENCL=OFF
                -DBUILD_TESTS=OFF
                -DBUILD_LIST=core,improc,photo,objdetect,video,imgcodecs,videoio,features2d,xfeatures2d,version,mcc,optflow
                -DCMAKE_INSTALL_PREFIX:PATH=<INSTALL_DIR>
                <SOURCE_DIR>
            BUILD_COMMAND $(MAKE) -j${CPU_CORES}
            DEPENDS opencv_contrib tbb zlib openexr tiff png turbojpeg libraw ffmpeg
        )
        
        # Add a step to mark this dependency as built
        add_mark_built_step(${OPENCV_TARGET} ${AV_DEPS_VERSION})
        add_mark_built_step(opencv_contrib ${AV_DEPS_VERSION})
    else()
        message(STATUS "OpenCV ${OPENCV_VERSION} already built, skipping")
        
        # Create dummy targets for dependency tracking
        add_custom_target(${OPENCV_TARGET}
            COMMAND ${CMAKE_COMMAND} -E echo "OpenCV already built, skipping."
        )
        
        add_custom_target(opencv_contrib
            COMMAND ${CMAKE_COMMAND} -E echo "OpenCV Contrib already built, skipping."
        )
    endif()
    
    # Register these dependencies
    register_dependency(${OPENCV_TARGET})
    register_dependency(opencv_contrib)
    
    # Set flags for other dependencies that use OpenCV
    set(OPENCV_CMAKE_FLAGS 
        -DOpenCV_DIR=${CMAKE_INSTALL_PREFIX}/${CMAKE_INSTALL_LIBDIR}/cmake/opencv4 
        -DOPENCV_DIR=${CMAKE_INSTALL_PREFIX}/${CMAKE_INSTALL_LIBDIR}/cmake/opencv4
    )
endif()
