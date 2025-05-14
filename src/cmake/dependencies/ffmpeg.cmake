# src/cmake/dependencies/ffmpeg.cmake

# Build configuration for FFmpeg

if(AV_BUILD_FFMPEG)
    set(FFMPEG_TARGET ffmpeg)
    set(FFMPEG_VERSION "5.1.6")
    set(FFMPEG_HASH "MD5=547725dd393a6adc1511da1fd141df25")
    
    # Check if this dependency needs to be rebuilt
    needs_rebuild(${FFMPEG_TARGET} ${AV_DEPS_VERSION} FFMPEG_NEEDS_REBUILD)
    
    if(FFMPEG_NEEDS_REBUILD)
        message(STATUS "Building FFmpeg ${FFMPEG_VERSION}")
        
        # First build VPX dependency if needed
        if(AV_BUILD_VPX)
            set(VPX_TARGET libvpx)
            set(VPX_VERSION "1.15.1")
            
            needs_rebuild(${VPX_TARGET} ${AV_DEPS_VERSION} VPX_NEEDS_REBUILD)
            
            if(VPX_NEEDS_REBUILD)
                message(STATUS "Building libvpx ${VPX_VERSION} for FFmpeg")
                
                ExternalProject_add(${VPX_TARGET}
                    GIT_REPOSITORY https://chromium.googlesource.com/webm/libvpx.git
                    GIT_TAG v${VPX_VERSION}
                    GIT_PROGRESS OFF
                    DOWNLOAD_EXTRACT_TIMESTAMP TRUE
                    PREFIX ${BUILD_DIR}
                    BUILD_IN_SOURCE 0
                    BUILD_ALWAYS 0
                    UPDATE_COMMAND ""
                    INSTALL_DIR ${CMAKE_INSTALL_PREFIX}
                    CONFIGURE_COMMAND <SOURCE_DIR>/configure --prefix=<INSTALL_DIR>
                        --enable-shared --disable-static --disable-examples
                    BUILD_COMMAND $(MAKE) -j${CPU_CORES}
                )
                
                add_mark_built_step(${VPX_TARGET} ${AV_DEPS_VERSION})
            else()
                message(STATUS "libvpx ${VPX_VERSION} already built, skipping")
                
                add_custom_target(${VPX_TARGET}
                    COMMAND ${CMAKE_COMMAND} -E echo "libvpx already built, skipping."
                )
            endif()
            
            register_dependency(${VPX_TARGET})
        endif()
        
        # Now build FFmpeg
        ExternalProject_add(${FFMPEG_TARGET}
            URL http://ffmpeg.org/releases/ffmpeg-${FFMPEG_VERSION}.tar.bz2
            URL_HASH ${FFMPEG_HASH}
            DOWNLOAD_DIR ${BUILD_DIR}/download/ffmpeg
            DOWNLOAD_EXTRACT_TIMESTAMP TRUE
            PREFIX ${BUILD_DIR}
            BUILD_IN_SOURCE 0
            BUILD_ALWAYS 0
            SOURCE_DIR ${CMAKE_CURRENT_BINARY_DIR}/ffmpeg
            UPDATE_COMMAND ""
            INSTALL_DIR ${CMAKE_INSTALL_PREFIX}
            CONFIGURE_COMMAND <SOURCE_DIR>/configure 
                --prefix=<INSTALL_DIR>
                --extra-cflags="-I<INSTALL_DIR>/include"
                --extra-ldflags="-L<INSTALL_DIR>/lib"
                --enable-shared
                --disable-static
                --disable-gpl
                --enable-nonfree
                --enable-libvpx
            BUILD_COMMAND $(MAKE) -j${CPU_CORES}
            DEPENDS libvpx
        )
        
        # Add a step to mark this dependency as built
        add_mark_built_step(${FFMPEG_TARGET} ${AV_DEPS_VERSION})
    else()
        message(STATUS "FFmpeg ${FFMPEG_VERSION} already built, skipping")
        
        # Create dummy targets for dependency tracking
        add_custom_target(${FFMPEG_TARGET}
            COMMAND ${CMAKE_COMMAND} -E echo "FFmpeg already built, skipping."
        )
        
        if(AV_BUILD_VPX)
            add_custom_target(libvpx
                COMMAND ${CMAKE_COMMAND} -E echo "libvpx already built, skipping."
            )
        endif()
    endif()
    
    # Register this dependency
    register_dependency(${FFMPEG_TARGET})
    
    # Set flags for other dependencies that use FFmpeg
    set(FFMPEG_CMAKE_FLAGS -DCMAKE_PREFIX_PATH=${CMAKE_INSTALL_PREFIX};${CMAKE_PREFIX_PATH})
endif()
