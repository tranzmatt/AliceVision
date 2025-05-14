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
# NOTE: Order is important as some dependencies depend on others

# Core dependencies
if(AV_BUILD_ZLIB)
    include(${CMAKE_CURRENT_LIST_DIR}/dependencies/zlib.cmake)
endif()

if(AV_BUILD_EIGEN)
    include(${CMAKE_CURRENT_LIST_DIR}/dependencies/eigen.cmake)
endif()

if(AV_BUILD_TBB)
    include(${CMAKE_CURRENT_LIST_DIR}/dependencies/tbb.cmake)
endif()

if(AV_BUILD_BOOST)
    include(${CMAKE_CURRENT_LIST_DIR}/dependencies/boost.cmake)
endif()

if(AV_BUILD_EXPAT)
    include(${CMAKE_CURRENT_LIST_DIR}/dependencies/expat.cmake)
endif()

# Compression and image format dependencies
if(AV_BUILD_LZ4)
    include(${CMAKE_CURRENT_LIST_DIR}/dependencies/lz4.cmake)
endif()

if(AV_BUILD_JPEG)
    include(${CMAKE_CURRENT_LIST_DIR}/dependencies/turbojpeg.cmake)
endif()

if(AV_BUILD_PNG)
    include(${CMAKE_CURRENT_LIST_DIR}/dependencies/png.cmake)
endif()

if(AV_BUILD_TIFF)
    include(${CMAKE_CURRENT_LIST_DIR}/dependencies/tiff.cmake)
endif()

if(AV_BUILD_OPENEXR)
    include(${CMAKE_CURRENT_LIST_DIR}/dependencies/openexr.cmake)
endif()

if(AV_BUILD_LIBRAW)
    include(${CMAKE_CURRENT_LIST_DIR}/dependencies/libraw.cmake)
endif()

# Math and optimization dependencies
if(AV_BUILD_LAPACK)
    include(${CMAKE_CURRENT_LIST_DIR}/dependencies/lapack.cmake)
endif()

if(AV_BUILD_SUITESPARSE)
    include(${CMAKE_CURRENT_LIST_DIR}/dependencies/suitesparse.cmake)
endif()

if(AV_BUILD_CERES)
    include(${CMAKE_CURRENT_LIST_DIR}/dependencies/ceres.cmake)
endif()

# COIN-OR optimization libraries
if(AV_BUILD_COINUTILS)
    include(${CMAKE_CURRENT_LIST_DIR}/dependencies/coinutils.cmake)
endif()

if(AV_BUILD_OSI)
    include(${CMAKE_CURRENT_LIST_DIR}/dependencies/osi.cmake)
endif()

if(AV_BUILD_CLP)
    include(${CMAKE_CURRENT_LIST_DIR}/dependencies/clp.cmake)
endif()

# Image processing and computer vision libraries
if(AV_BUILD_OPENIMAGEIO)
    include(${CMAKE_CURRENT_LIST_DIR}/dependencies/openimageio.cmake)
endif()

if(AV_BUILD_FFMPEG)
    include(${CMAKE_CURRENT_LIST_DIR}/dependencies/ffmpeg.cmake)
endif()

if(AV_BUILD_OPENCV)
    include(${CMAKE_CURRENT_LIST_DIR}/dependencies/opencv.cmake)
endif()

if(AV_BUILD_ONNXRUNTIME)
    include(${CMAKE_CURRENT_LIST_DIR}/dependencies/onnxruntime.cmake)
endif()

# Feature extraction and matching libraries
if(AV_BUILD_FLANN)
    include(${CMAKE_CURRENT_LIST_DIR}/dependencies/flann.cmake)
endif()

if(AV_BUILD_NANOFLANN)
    include(${CMAKE_CURRENT_LIST_DIR}/dependencies/nanoflann.cmake)
endif()

if(AV_BUILD_OPENGV)
    include(${CMAKE_CURRENT_LIST_DIR}/dependencies/opengv.cmake)
endif()

if(AV_BUILD_POPSIFT)
    include(${CMAKE_CURRENT_LIST_DIR}/dependencies/popsift.cmake)
endif()

if(AV_BUILD_CCTAG)
    include(${CMAKE_CURRENT_LIST_DIR}/dependencies/cctag.cmake)
endif()

if(AV_BUILD_APRILTAG)
    include(${CMAKE_CURRENT_LIST_DIR}/dependencies/apriltag.cmake)
endif()

# Geometry and mesh libraries
if(AV_BUILD_GEOGRAM)
    include(${CMAKE_CURRENT_LIST_DIR}/dependencies/geogram.cmake)
endif()

if(AV_BUILD_ALEMBIC)
    include(${CMAKE_CURRENT_LIST_DIR}/dependencies/alembic.cmake)
endif()

if(AV_BUILD_ASSIMP)
    include(${CMAKE_CURRENT_LIST_DIR}/dependencies/assimp.cmake)
endif()

if(AV_BUILD_OPENMESH)
    include(${CMAKE_CURRENT_LIST_DIR}/dependencies/openmesh.cmake)
endif()

if(AV_BUILD_LEMON)
    include(${CMAKE_CURRENT_LIST_DIR}/dependencies/lemon.cmake)
endif()

if(AV_BUILD_E57FORMAT)
    include(${CMAKE_CURRENT_LIST_DIR}/dependencies/e57format.cmake)
endif()

# Tools and language bindings
if(AV_BUILD_SWIG)
    include(${CMAKE_CURRENT_LIST_DIR}/dependencies/swig.cmake)
endif()

# Set the final dependency list for AliceVision's main build
set(AV_DEPS ${AV_ALL_DEPS})