# src/cmake/Dependencies.cmake

# Main AliceVision Dependencies CMake file
# Now modularized for selective rebuilding

include(ExternalProject)

# Include core functionality and options
include(${CMAKE_CURRENT_LIST_DIR}/dependencies/core.cmake)
include(${CMAKE_CURRENT_LIST_DIR}/dependencies/options.cmake)

# Create mark_built helper script
configure_file(
    ${CMAKE_CURRENT_LIST_DIR}/dependencies/mark_built.cmake.in
    ${CMAKE_CURRENT_LIST_DIR}/dependencies/mark_built.cmake
    @ONLY
)

# Log all build options
include(${CMAKE_CURRENT_LIST_DIR}/dependencies/options_logging.cmake)

# Include individual dependencies based on build options
if(AV_BUILD_ZLIB)
    include(${CMAKE_CURRENT_LIST_DIR}/dependencies/zlib.cmake)
endif()

if(AV_BUILD_EIGEN)
    include(${CMAKE_CURRENT_LIST_DIR}/dependencies/eigen.cmake)
endif()

if(AV_BUILD_ONNXRUNTIME)
    include(${CMAKE_CURRENT_LIST_DIR}/dependencies/onnxruntime.cmake)
endif()

if(AV_BUILD_BOOST)
    include(${CMAKE_CURRENT_LIST_DIR}/dependencies/boost.cmake)
endif()

if(AV_BUILD_GEOGRAM)
    include(${CMAKE_CURRENT_LIST_DIR}/dependencies/geogram.cmake)
endif()

if(AV_BUILD_FLANN)
    include(${CMAKE_CURRENT_LIST_DIR}/dependencies/flann.cmake)
endif()

# Note: The order here matters - dependencies that are required by other
# dependencies need to be included first to ensure proper build order
# For a full implementation, include all the dependencies in order

# The following is a placeholder for the remaining dependencies
# In a complete implementation, each would have its own file:

# if(AV_BUILD_ASSIMP)
#     include(${CMAKE_CURRENT_LIST_DIR}/dependencies/assimp.cmake)
# endif()

# if(AV_BUILD_TBB)
#     include(${CMAKE_CURRENT_LIST_DIR}/dependencies/tbb.cmake)
# endif()

# ... etc. for all dependencies

# Set the final dependency list for AliceVision's main build
set(AV_DEPS ${AV_ALL_DEPS})