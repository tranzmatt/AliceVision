# src/cmake/dependencies/options.cmake

# Option declarations for all dependencies
# All build options with descriptions

option(AV_BUILD_DEPENDENCIES_PARALLEL "Number of cores to use when building dependencies (0 - use the number of cores of the processor)" 0)
option(AV_ONNX_APPLE_ARCH "Version to download OFF Apple [arm64, x86_64]" "arm64")

option(AV_BUILD_CUDA "Enable building an embedded Cuda" OFF)
option(AV_BUILD_ZLIB "Enable building an embedded ZLIB" OFF)
option(AV_BUILD_ASSIMP "Enable building an embedded ASSIMP" ON)
option(AV_BUILD_TIFF "Enable building an embedded Tiff" ON)
option(AV_BUILD_JPEG "Enable building an embedded Jpeg" ON)
option(AV_BUILD_PNG "Enable building an embedded Png" ON)
option(AV_BUILD_LIBRAW "Enable building an embedded libraw" ON)
option(AV_BUILD_POPSIFT "Enable building an embedded PopSift" ON)
option(AV_BUILD_CCTAG "Enable building an embedded CCTag" ON)
option(AV_BUILD_APRILTAG "Enable building an embedded AprilTag" ON)
option(AV_BUILD_OPENGV "Enable building an embedded OpenGV" ON)
option(AV_BUILD_OPENCV "Enable building an embedded OpenCV" ON)
option(AV_BUILD_ONNXRUNTIME "Enable building an embedded ONNX runtime" ON)
option(AV_BUILD_LAPACK "Enable building an embedded Lapack" ON)
option(AV_BUILD_SUITESPARSE "Enable building an embedded SuiteSparse" ON)
option(AV_BUILD_FFMPEG "Enable building an embedded FFMpeg" ON)
option(AV_BUILD_VPX "Enable building an embedded libvpx required for ffmpeg" ON)
option(AV_BUILD_COINUTILS "Enable building an embedded CoinUtils" ON)
option(AV_BUILD_OSI "Enable building an embedded Osi" ON)
option(AV_BUILD_CLP "Enable building an embedded Clp" ON)
option(AV_BUILD_FLANN "Enable building an embedded Flann" ON)
option(AV_BUILD_NANOFLANN "Enable building an embedded NanoFlann" ON)
option(AV_BUILD_LEMON "Enable building an embedded LEMON library" ON)
option(AV_BUILD_E57FORMAT "Enable building an embedded E57Format" ON)
option(AV_BUILD_PCL "Enable building an embedded PointCloud library" OFF)
option(AV_BUILD_USD "Enable building an embedded USD library" OFF)
option(AV_BUILD_GEOGRAM "Enable building an embedded Geogram library" ON)
option(AV_BUILD_TBB "Enable building an embedded TBB library" ON)
option(AV_BUILD_EIGEN "Enable building an embedded Eigen library" ON)
option(AV_BUILD_EXPAT "Enable building an embedded Expat library" ON)
option(AV_BUILD_OPENEXR "Enable building an embedded OpenExr library" ON)
option(AV_BUILD_ALEMBIC "Enable building an embedded Alembic library" ON)
option(AV_BUILD_OPENIMAGEIO "Enable building an embedded OpenImageIO library" ON)
option(AV_BUILD_BOOST "Enable building an embedded Boost library" ON)
option(AV_BUILD_CERES "Enable building an embedded Ceres library" ON)
option(AV_BUILD_SWIG "Enable building an embedded SWIG library" ON)
option(AV_BUILD_OPENMESH "Enable building an embedded OpenMesh library" ON)

# Dependencies version tracking for rebuild detection
set(AV_DEPS_VERSION "2025.02.21" CACHE STRING "Dependencies version for rebuild tracking")

# Check CPU cores for parallel builds
check_cpu_cores(CPU_CORES)
message(STATUS "Build multithreading number of cores: ${CPU_CORES}")