# src/cmake/dependencies/core.cmake

include(ExternalProject)

# Directory for all dependency builds
set(BUILD_DIR "${CMAKE_CURRENT_BINARY_DIR}/external" CACHE INTERNAL "Build directory for external dependencies")

# Common CMake flags for all dependencies
set(CMAKE_CORE_BUILD_FLAGS 
    -DCMAKE_BUILD_TYPE=${DEPS_CMAKE_BUILD_TYPE} 
    -DBUILD_SHARED_LIBS:BOOL=${BUILD_SHARED_LIBS} 
    -DCMAKE_INSTALL_DO_STRIP:BOOL=${CMAKE_INSTALL_DO_STRIP} 
    -DCMAKE_C_COMPILER=${CMAKE_C_COMPILER} 
    -DCMAKE_CXX_COMPILER=${CMAKE_CXX_COMPILER} 
    -DCMAKE_CXX_STANDARD=17
    -DCMAKE_POLICY_VERSION_MINIMUM=3.5
)

# Create a stamp file to track when a dependency was built
function(mark_dependency_built name version)
    file(WRITE "${BUILD_DIR}/${name}_built.stamp" "${version}")
endfunction()

# Check if dependency needs rebuilding
function(needs_rebuild name version result_var)
    set(stamp_file "${BUILD_DIR}/${name}_built.stamp")
    set(${result_var} TRUE PARENT_SCOPE)
    
    if(EXISTS ${stamp_file})
        file(READ ${stamp_file} built_version)
        if("${built_version}" STREQUAL "${version}")
            set(${result_var} FALSE PARENT_SCOPE)
        endif()
    endif()
endfunction()

# Global list of all dependencies for the main AliceVision build
set(AV_ALL_DEPS "" CACHE INTERNAL "All dependencies to build")

# Register a dependency in the global list
function(register_dependency name)
    list(APPEND AV_ALL_DEPS ${name})
    set(AV_ALL_DEPS "${AV_ALL_DEPS}" CACHE INTERNAL "")
endfunction()

# Helper function to add a mark_built step to an ExternalProject
function(add_mark_built_step target version)
    ExternalProject_Add_Step(${target} mark_built
        COMMAND ${CMAKE_COMMAND} -E make_directory ${BUILD_DIR}
        COMMAND ${CMAKE_COMMAND} -E echo "Marking ${target} as built with version ${version}"
        COMMAND ${CMAKE_COMMAND} -E echo "${version}" > ${BUILD_DIR}/${target}_built.stamp
        DEPENDEES install
    )
endfunction()

# Helper to check host processor architecture
function(check_cpu_cores output_var)
    if(NOT DEFINED AV_BUILD_DEPENDENCIES_PARALLEL OR AV_BUILD_DEPENDENCIES_PARALLEL EQUAL 0)
        # Try to auto-detect the number of cores
        if(CMAKE_SYSTEM_NAME MATCHES "Linux")
            execute_process(
                COMMAND nproc
                OUTPUT_VARIABLE CPU_CORES
                OUTPUT_STRIP_TRAILING_WHITESPACE
            )
        elseif(CMAKE_SYSTEM_NAME MATCHES "Darwin")
            execute_process(
                COMMAND sysctl -n hw.ncpu
                OUTPUT_VARIABLE CPU_CORES
                OUTPUT_STRIP_TRAILING_WHITESPACE
            )
        elseif(CMAKE_SYSTEM_NAME MATCHES "Windows")
            set(CPU_CORES $ENV{NUMBER_OF_PROCESSORS})
        else()
            set(CPU_CORES 4) # Default to 4 cores if detection fails
        endif()
    else()
        set(CPU_CORES ${AV_BUILD_DEPENDENCIES_PARALLEL})
    endif()
    
    set(${output_var} ${CPU_CORES} PARENT_SCOPE)
endfunction()
