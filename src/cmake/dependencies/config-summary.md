# Configuration Summary

I have created CMake configuration files for all the dependencies you mentioned:

1. `turbojpeg.cmake` - TurboJPEG library
2. `boost.cmake` - Boost C++ libraries
3. `openexr.cmake` - OpenEXR high dynamic range image format
4. `tbb.cmake` - Intel Threading Building Blocks
5. `assimp.cmake` - Open Asset Import Library
6. `geogram.cmake` - Geogram geometric algorithms
7. `eigen.cmake` - Eigen linear algebra library
8. `opengv.cmake` - OpenGV geometric vision library
9. `lapack.cmake` - Linear Algebra PACKage
10. `suitesparse.cmake` - SuiteSparse sparse matrix collection
11. `ceres.cmake` - Ceres Solver optimization library
12. `tiff.cmake` - TIFF image format library
13. `zlib.cmake` - zlib compression library
14. `png.cmake` - PNG image format library
15. `libraw.cmake` - LibRaw raw image processing
16. `openimageio.cmake` - OpenImageIO image I/O library
17. `alembic.cmake` - Alembic file format for computer graphics
18. `ffmpeg.cmake` - FFmpeg multimedia library
19. `opencv.cmake` - OpenCV computer vision library
20. `expat.cmake` - Expat XML parser library
21. `cctag.cmake` - CCTag marker detection
22. `popsift.cmake` - PopSift GPU SIFT implementation
23. `coinutils.cmake` - CoinUtils optimization library
24. `osi.cmake` - Open Solver Interface
25. `clp.cmake` - COIN-OR Linear Programming
26. `openmesh.cmake` - OpenMesh mesh processing
27. `lz4.cmake` - LZ4 compression algorithm
28. `flann.cmake` - Fast Library for Approximate Nearest Neighbors
29. `nanoflann.cmake` - Header-only library for nearest neighbor search
30. `lemon.cmake` - Library for Efficient Modeling and Optimization in Networks
31. `swig.cmake` - Simplified Wrapper and Interface Generator
32. `e57format.cmake` - E57 3D point cloud format
33. `onnxruntime.cmake` - ONNX Runtime for machine learning
34. `apriltag.cmake` - AprilTag fiducial marker detection

Additionally, I've provided:

1. `core.cmake` - Core dependency tracking functions
2. `options.cmake` - Build options declarations
3. `options_logging.cmake` - Logging of build options
4. `mark_built.cmake.in` - Template for dependency stamps
5. `dependencies-cmake-complete` - Main Dependencies.cmake file that orchestrates all modules

I've also created build script modifications:
- Updated `build-ubuntu.sh` and `build-rocky.sh` to track dependency changes
- Updated `Dockerfile_ubuntu_deps` and `Dockerfile_rocky_deps` to support selective rebuilding

This modular structure allows selective rebuilding of dependencies when any individual dependency file is modified. Each dependency module:
1. Checks if the dependency needs rebuilding
2. Only rebuilds when necessary
3. Creates dummy targets when no rebuild is needed
4. Registers dependencies for proper tracking

These files align with the list of dependencies you need to support and implement the selective rebuild mechanism we discussed.