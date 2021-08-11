cmake_minimum_required(VERSION 3.5)

set(benchmark_URL "https://github.com/google/benchmark/archive/a4bcd937b298fdc2b0c7da9961fa202a5aecd56b.zip")
set(benchmark_PREFIX "benchmark-a4bcd937b298fdc2b0c7da9961fa202a5aecd56b")
set(benchmark_SHA256 "a6abcbe9dec091cd570462bf712661d3944f73f964f82501456eaa5f89036b1a")

file(DOWNLOAD ${benchmark_URL} benchmark.zip SHOW_PROGRESS EXPECTED_HASH SHA256=${benchmark_SHA256})
file(ARCHIVE_EXTRACT INPUT benchmark.zip DESTINATION ${CMAKE_CURRENT_SOURCE_DIR})

add_subdirectory(${CMAKE_CURRENT_SOURCE_DIR}/${benchmark_PREFIX})
include_directories(${CMAKE_CURRENT_SOURCE_DIR}/${benchmark_PREFIX})
