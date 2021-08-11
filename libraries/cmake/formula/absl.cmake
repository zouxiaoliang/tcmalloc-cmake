cmake_minimum_required(VERSION 3.5)

set(abseil_URL "https://github.com/abseil/abseil-cpp/archive/7971fb358ae376e016d2d4fc9327aad95659b25e.zip")
set(abseil_PREFIX "abseil-cpp-7971fb358ae376e016d2d4fc9327aad95659b25e")
set(abseil_SHA256 "aeba534f7307e36fe084b452299e49b97420667a8d28102cf9a0daeed340b859")

file(DOWNLOAD ${abseil_URL} abseil-cpp.zip SHOW_PROGRESS EXPECTED_HASH SHA256=${abseil_SHA256})
file(ARCHIVE_EXTRACT INPUT abseil-cpp.zip DESTINATION ${CMAKE_CURRENT_SOURCE_DIR})

add_subdirectory(${CMAKE_CURRENT_SOURCE_DIR}/${abseil_PREFIX})
include_directories(${CMAKE_CURRENT_SOURCE_DIR}/${abseil_PREFIX})
