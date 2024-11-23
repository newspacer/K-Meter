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


project(K-Meter
    VERSION ${GIT_TAG_VERSION}
    LANGUAGES C CXX)


add_subdirectory(externals)

add_subdirectory(Source)

if(${KMETER_SURROUND})
    set(PACKAGE_NAME K-Meter_surround)
else()
    set(PACKAGE_NAME K-Meter)
endif()

set(CPACK_PACKAGE_NAME ${PACKAGE_NAME})
set(CPACK_PACKAGE_VERSION ${GIT_TAG_VERSION})
set(CPACK_GENERATOR "ZIP")

include(CPack)

