
find_package(Git REQUIRED)


execute_process(COMMAND ${GIT_EXECUTABLE} describe --tags
    WORKING_DIRECTORY ${CMAKE_SOURCE_DIR}
    OUTPUT_VARIABLE GIT_TAG
    OUTPUT_STRIP_TRAILING_WHITESPACE)

message(STATUS "GitUtils: found tag '${GIT_TAG}'")


string(REGEX MATCH "([0-9]\.[0-9]\.[0-9])"
    GIT_TAG_VERSION ${GIT_TAG})


message(STATUS "GitUtils: found version '${GIT_TAG_VERSION}'")

