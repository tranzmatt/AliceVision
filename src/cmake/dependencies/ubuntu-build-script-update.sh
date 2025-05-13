#!/bin/bash

# Script to update docker/build-ubuntu.sh to support selective dependency rebuilding

# Add the following to docker/build-ubuntu.sh just before the Docker build command:

# Generate a hash of the current dependencies
DEPS_CHANGED=0

# Create build directory if it doesn't exist
mkdir -p "${BUILD_DIR}"

# Check if any dependency CMake file has changed
for DEP_FILE in $(find "${AV_ROOT}/src/cmake/dependencies" -type f -name "*.cmake"); do
    DEP_NAME=$(basename "${DEP_FILE}" .cmake)
    DEP_HASH_FILE="${BUILD_DIR}/deps_${DEP_NAME}_hash.txt"
    CURRENT_HASH=$(md5sum "${DEP_FILE}" | cut -d' ' -f1)
    
    if [ -f "${DEP_HASH_FILE}" ]; then
        STORED_HASH=$(cat "${DEP_HASH_FILE}")
        if [ "${STORED_HASH}" != "${CURRENT_HASH}" ]; then
            echo "Dependency ${DEP_NAME} has changed"
            DEPS_CHANGED=1
            echo "${CURRENT_HASH}" > "${DEP_HASH_FILE}"
        fi
    else
        echo "New dependency file: ${DEP_NAME}"
        DEPS_CHANGED=1
        mkdir -p $(dirname "${DEP_HASH_FILE}")
        echo "${CURRENT_HASH}" > "${DEP_HASH_FILE}"
    fi
done

# Also check if the main Dependencies.cmake file has changed
MAIN_DEPS_FILE="${AV_ROOT}/src/cmake/Dependencies.cmake"
MAIN_DEPS_HASH_FILE="${BUILD_DIR}/deps_main_hash.txt"
CURRENT_MAIN_HASH=$(md5sum "${MAIN_DEPS_FILE}" | cut -d' ' -f1)

if [ -f "${MAIN_DEPS_HASH_FILE}" ]; then
    STORED_MAIN_HASH=$(cat "${MAIN_DEPS_HASH_FILE}")
    if [ "${STORED_MAIN_HASH}" != "${CURRENT_MAIN_HASH}" ]; then
        echo "Main Dependencies.cmake file has changed"
        DEPS_CHANGED=1
        echo "${CURRENT_MAIN_HASH}" > "${MAIN_DEPS_HASH_FILE}"
    fi
else
    echo "First build or missing hash for main Dependencies.cmake"
    DEPS_CHANGED=1
    mkdir -p $(dirname "${MAIN_DEPS_HASH_FILE}")
    echo "${CURRENT_MAIN_HASH}" > "${MAIN_DEPS_HASH_FILE}"
fi

# Update the AV_DEPS_VERSION if dependencies changed
if [ "${DEPS_CHANGED}" -eq 1 ]; then
    echo "Dependencies have changed, updating AV_DEPS_VERSION"
    AV_DEPS_VERSION="$(date +%Y.%m.%d.%H%M%S)"
    echo "New AV_DEPS_VERSION: ${AV_DEPS_VERSION}"
else
    echo "Dependencies unchanged, using existing AV_DEPS_VERSION: ${AV_DEPS_VERSION}"
fi

# Allow force rebuild with environment variable
if [ "${FORCE_REBUILD_DEPS}" = "1" ]; then
    echo "Forcing dependency rebuild as requested by FORCE_REBUILD_DEPS=1"
    AV_DEPS_VERSION="$(date +%Y.%m.%d.%H%M%S)"
fi

# Then update the Docker build command to pass the AV_DEPS_VERSION:
#
# docker build \
#     --rm \
#     --build-arg CUDA_VERSION=${CUDA_VERSION} \
#     --build-arg UBUNTU_VERSION=${UBUNTU_VERSION} \
#     --build-arg AV_DEPS_VERSION=${AV_DEPS_VERSION} \
#     --tag ${DEPS_DOCKER_TAG} \
#     -f docker/Dockerfile_ubuntu_deps .
