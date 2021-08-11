cmake_minimum_required(VERSION 3.5)

set(googletest_URL "https://github.com/google/googletest/archive/aa9b44a18678dfdf57089a5ac22c1edb69f35da5.zip")
set(googletest_PREFIX "googletest-aa9b44a18678dfdf57089a5ac22c1edb69f35da5")
set(googletest_SHA256 "8cf4eaab3a13b27a95b7e74c58fb4c0788ad94d1f7ec65b20665c4caf1d245e8")

file(DOWNLOAD ${googletest_URL} googletest.zip SHOW_PROGRESS EXPECTED_HASH SHA256=${googletest_SHA256})
file(ARCHIVE_EXTRACT INPUT googletest.zip DESTINATION ${CMAKE_CURRENT_SOURCE_DIR})

add_subdirectory(${CMAKE_CURRENT_SOURCE_DIR}/${googletest_PREFIX})
include_directories(${CMAKE_CURRENT_SOURCE_DIR}/${googletest_PREFIX})
