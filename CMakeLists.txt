cmake_minimum_required(VERSION 3.24)

set(CMAKE_CXX_STANDARD 20)
set(CMAKE_CXX_STANDARD_REQUIRED ON)

set(VERSION 2.8.2)

option(KMETER_SURROUND "Build surround plugin (default=stereo)" OFF)

if(${KMETER_SURROUND})
    set(PROJECT_NAME K-Meter_surround)
else()
    set(PROJECT_NAME K-Meter)
endif()

project(${PROJECT_NAME}
    VERSION ${VERSION}
    LANGUAGES C CXX)


add_subdirectory(externals)

add_subdirectory(Source)

set(CPACK_PROJECT_NAME ${PROJECT_NAME})
set(CPACK_PACKAGE_VERSION ${VERSION})
set(CPACK_GENERATOR "ZIP")

include(CPack)

