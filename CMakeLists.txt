cmake_minimum_required(VERSION 3.24)

set(CMAKE_CXX_STANDARD 20)
set(CMAKE_CXX_STANDARD_REQUIRED ON)

project(K-Meter
    VERSION 2.8.2
    LANGUAGES CXX)

option(KMETER_SURROUND "Build surround plugin (default=stereo)" OFF)

add_subdirectory(externals)

add_subdirectory(Source)

