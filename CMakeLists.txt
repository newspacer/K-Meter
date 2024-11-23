cmake_minimum_required(VERSION 3.24)

set(CMAKE_CXX_STANDARD 20)
set(CMAKE_CXX_STANDARD_REQUIRED ON)

set(VERSION 2.8.2)

project(K-Meter
    VERSION ${VERSION}
    LANGUAGES CXX)

option(KMETER_SURROUND "Build surround plugin (default=stereo)" OFF)

add_subdirectory(externals)

add_subdirectory(Source)

set(CPACK_PROJECT_NAME K-Meter)
set(CPACK_PACKAGE_VERSION ${VERSION})
set(CPACK_GENERATOR "ZIP")

include(CPack)

