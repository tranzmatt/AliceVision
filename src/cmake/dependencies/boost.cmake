# src/cmake/dependencies/boost.cmake

# Build configuration for Boost

if(AV_BUILD_BOOST)
    set(BOOST_TARGET boost)
    set(BOOST_VERSION "1.88.0")
    set(BOOST_HASH "MD5=190701c5017cb9931f12da00db225423")
    
    # Check if this dependency needs to be rebuilt
    needs_rebuild(${BOOST_TARGET} ${AV_DEPS_VERSION} BOOST_NEEDS_REBUILD)
    
    if(BOOST_NEEDS_REBUILD)
        message(STATUS "Building Boost ${BOOST_VERSION}")
        
        # Determine script extension based on platform
        if(WIN32)
            set(SCRIPT_EXTENSION bat)
        else()
            set(SCRIPT_EXTENSION sh)
        endif()
        
        # Use lowercase build type
        string(TOLOWER "${DEPS_CMAKE_BUILD_TYPE}" DEPS_CMAKE_BUILD_TYPE_LOWERCASE)
        
        ExternalProject_Add(${BOOST_TARGET}
            URL https://archives.boost.io/release/${BOOST_VERSION}/source/boost_1_88_0.tar.bz2
            URL_HASH ${BOOST_HASH}
            DOWNLOAD_DIR ${BUILD_DIR}/download/boost
            PREFIX ${BUILD_DIR}
            BUILD_IN_SOURCE 0
            BUILD_ALWAYS 0
            UPDATE_COMMAND ""
            SOURCE_DIR ${CMAKE_CURRENT_BINARY_DIR}/boost
            BINARY_DIR ${BUILD_DIR}/boost_build
            INSTALL_DIR ${CMAKE_INSTALL_PREFIX}
            CONFIGURE_COMMAND
                cd <SOURCE_DIR> &&
                ./bootstrap.${SCRIPT_EXTENSION} --prefix=<INSTALL_DIR> --with-libraries=atomic,container,date_time,exception,graph,iostreams,json,log,math,program_options,regex,serialization,system,test,thread,stacktrace,timer
            BUILD_COMMAND
                cd <SOURCE_DIR> &&
                ./b2 --prefix=<INSTALL_DIR> variant=${DEPS_CMAKE_BUILD_TYPE_LOWERCASE} cxxstd=17 link=shared threading=multi -j${CPU_CORES}
            INSTALL_COMMAND
                cd <SOURCE_DIR> &&
                ./b2 variant=${DEPS_CMAKE_BUILD_TYPE_LOWERCASE} cxxstd=17 link=shared threading=multi install
            DEPENDS zlib
        )
        
        # Add a step to mark this dependency as built
        add_mark_built_step(${BOOST_TARGET} ${AV_DEPS_VERSION})
    else()
        message(STATUS "Boost ${BOOST_VERSION} already built, skipping")
        
        # Create dummy target for dependency tracking
        add_custom_target(${BOOST_TARGET}
            COMMAND ${CMAKE_COMMAND} -E echo "Boost already built, skipping."
        )
    endif()
    
    # Register this dependency
    register_dependency(${BOOST_TARGET})
    
    # Set flags for other dependencies that use Boost
    set(BOOST_CMAKE_FLAGS -DBOOST_ROOT=${CMAKE_INSTALL_PREFIX})
endif()