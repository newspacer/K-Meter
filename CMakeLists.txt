cmake_minimum_required(VERSION 3.24)

set(CMAKE_CXX_STANDARD 20)
set(CMAKE_CXX_STANDARD_REQUIRED ON)

set(CMAKE_MODULE_PATH ${CMAKE_SOURCE_DIR}/cmake)
include(GitUtils)


option(KMETER_SURROUND "Build surround plugin (default=stereo)" OFF)


set(plugin_formats VST3 Standalone)

if(${APPLE})
    list(APPEND plugin_formats AU)
endif()

if(${LINUX})
    list(APPEND plugin_formats LV2)
endif()


if(${KMETER_SURROUND})
    set(PROJECT_NAME K-Meter_surround)
else()
    set(PROJECT_NAME K-Meter)
endif()

project(${PROJECT_NAME}
    VERSION ${GIT_TAG_VERSION}
    LANGUAGES C CXX)


add_subdirectory(externals)

add_subdirectory(Source)

set(CPACK_PROJECT_NAME ${PROJECT_NAME})
set(CPACK_PACKAGE_VERSION ${GIT_TAG_VERSION})
set(CPACK_GENERATOR "ZIP")

include(CPack)

