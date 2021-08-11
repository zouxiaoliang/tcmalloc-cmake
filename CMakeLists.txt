cmake_minimum_required(VERSION 3.5)

project(tcmalloc-cmake LANGUAGES C CXX ASM)

set(CMAKE_CXX_STANDARD 17)
set(CMAKE_C_STANDARD 17)
set(CMAKE_CXX_STANDARD_REQUIRED ON)

option(TEST "create test project" OFF)

#set(LLVM_FLAGS "-Wno-deprecated-declarations -Wno-implicit-int-float-conversion -Wno-sign-compare -Wno-uninitialized -Wno-unused-function -Wno-unused-variable")
set(LLVM_FLAGS "-Wno-deprecated-declarations -Wno-implicit-float-conversion -Wno-sign-compare -Wno-uninitialized -Wno-unused-function -Wno-unused-variable -fsized-deallocation")

# https://gcc.gnu.org/bugzilla/show_bug.cgi?id=66425
set(GCC_FLAGS "-Wno-attribute-alias -Wno-sign-compare -Wno-uninitialized -Wno-unused-function -Wno-unused-result -Wno-unused-variable")

if (CMAKE_CXX_COMPILER_ID MATCHES "Clang")
    message(STATUS "tcmalloc using ${CMAKE_CXX_COMPILER_ID} as the complier")
    set(CMAKE_CXX_FLAGS ${LLVM_FLAGS})
elseif(CMAKE_CXX_COMPILER_ID STREQUAL "GNU")
    message(STATUS "tcmalloc using ${CMAKE_CXX_COMPILER_ID} as the complier")
    set(CMAKE_CXX_FLAGS ${GCC_FLAGS})
else()
    message(FATAL_ERROR "Unsupported complier [${CMAKE_CXX_COMPILER_ID}]")
endif()


# append the custom modlue path to cmake system path;
list(APPEND CMAKE_MODULE_PATH "${CMAKE_CURRENT_SOURCE_DIR}/libraries/cmake/formula")

include(absl)
if (TEST)
include(googletest)
include(benchmark)
endif()
# message(STATUS "CMAKE_MODULE_PATH: ${CMAKE_MODULE_PATH}")

set(TCMALLOC_PATH tcmalloc)
set(TCMALLOC_ROOT_PATH ${TCMALLOC_PATH}/tcmalloc)
set(TCMALLOC_TEST_PATH ${TCMALLOC_ROOT_PATH}/testing)
set(TCMALLOC_INTERNAL_PATH ${TCMALLOC_ROOT_PATH}/internal)

message(STATUS "LIBABSEIL_INCLUDE: ${LIBABSEIL_INCLUDE}")

include_directories(${TCMALLOC_PATH})
include_directories(${TCMALLOC_ROOT_PATH})
include_directories(${TCMALLOC_INTERNAL_PATH})


# ---- project: tcmalloc -----
# sources
set(tcmalloc_src
    tcmalloc/tcmalloc/libc_override.h
    tcmalloc/tcmalloc/libc_override_gcc_and_weak.h
    tcmalloc/tcmalloc/libc_override_glibc.h
    tcmalloc/tcmalloc/libc_override_redefine.h
    tcmalloc/tcmalloc/tcmalloc.cc
    tcmalloc/tcmalloc/tcmalloc.h
)
# project
add_library(tcmalloc ${tcmalloc_src})
# deps
target_link_libraries(tcmalloc
    absl::debugging
    absl::memory
    absl::base
    internal_percpu
    absl::strings
    common
    experiment
    internal_memory_stats
    absl::dynamic_annotations
    absl::leak_check
    malloc_extension
    internal_logging
    absl::bits
)

# ---- project: common -----
# sources
set(common_src
    tcmalloc/tcmalloc/arena.cc
    tcmalloc/tcmalloc/arena.h
    tcmalloc/tcmalloc/background.cc
    tcmalloc/tcmalloc/central_freelist.cc
    tcmalloc/tcmalloc/central_freelist.h
    tcmalloc/tcmalloc/common.cc
    tcmalloc/tcmalloc/common.h
    tcmalloc/tcmalloc/cpu_cache.cc
    tcmalloc/tcmalloc/cpu_cache.h
    tcmalloc/tcmalloc/experimental_pow2_below64_size_class.cc
    tcmalloc/tcmalloc/experimental_pow2_size_class.cc
    tcmalloc/tcmalloc/guarded_page_allocator.cc
    tcmalloc/tcmalloc/guarded_page_allocator.h
    tcmalloc/tcmalloc/huge_address_map.cc
    tcmalloc/tcmalloc/huge_address_map.h
    tcmalloc/tcmalloc/huge_allocator.cc
    tcmalloc/tcmalloc/huge_allocator.h
    tcmalloc/tcmalloc/huge_cache.cc
    tcmalloc/tcmalloc/huge_cache.h
    tcmalloc/tcmalloc/huge_page_aware_allocator.cc
    tcmalloc/tcmalloc/huge_page_aware_allocator.h
    tcmalloc/tcmalloc/huge_page_filler.h
    tcmalloc/tcmalloc/huge_pages.h
    tcmalloc/tcmalloc/huge_region.h
    tcmalloc/tcmalloc/legacy_size_classes.cc
    tcmalloc/tcmalloc/page_allocator.cc
    tcmalloc/tcmalloc/page_allocator.h
    tcmalloc/tcmalloc/page_allocator_interface.cc
    tcmalloc/tcmalloc/page_allocator_interface.h
    tcmalloc/tcmalloc/page_heap.cc
    tcmalloc/tcmalloc/page_heap.h
    tcmalloc/tcmalloc/page_heap_allocator.h
    tcmalloc/tcmalloc/pagemap.cc
    tcmalloc/tcmalloc/pagemap.h
    tcmalloc/tcmalloc/pages.h
    tcmalloc/tcmalloc/parameters.cc
    tcmalloc/tcmalloc/parameters.h
    tcmalloc/tcmalloc/peak_heap_tracker.cc
    tcmalloc/tcmalloc/peak_heap_tracker.h
    tcmalloc/tcmalloc/sampler.cc
    tcmalloc/tcmalloc/sampler.h
    tcmalloc/tcmalloc/size_classes.cc
    tcmalloc/tcmalloc/span.cc
    tcmalloc/tcmalloc/span.h
    tcmalloc/tcmalloc/span_stats.h
    tcmalloc/tcmalloc/stack_trace_table.cc
    tcmalloc/tcmalloc/stack_trace_table.h
    tcmalloc/tcmalloc/static_vars.cc
    tcmalloc/tcmalloc/static_vars.h
    tcmalloc/tcmalloc/stats.cc
    tcmalloc/tcmalloc/stats.h
    tcmalloc/tcmalloc/system-alloc.cc
    tcmalloc/tcmalloc/system-alloc.h
    tcmalloc/tcmalloc/tcmalloc_policy.h
    tcmalloc/tcmalloc/thread_cache.cc
    tcmalloc/tcmalloc/thread_cache.h
    tcmalloc/tcmalloc/tracking.h
    tcmalloc/tcmalloc/transfer_cache.cc
    tcmalloc/tcmalloc/transfer_cache.h
    tcmalloc/tcmalloc/transfer_cache_internals.h
    tcmalloc/tcmalloc/transfer_cache_stats.h
)
# project
add_library(common ${common_src})
# deps
target_link_libraries(common
    internal_percpu
    absl::base
    internal_environment
    absl::debugging
    experiment
    absl::algorithm
    absl::strings
    internal_util
    absl::base
    absl::debugging
    absl::synchronization
    malloc_extension
    internal_mincore
    noruntime_size_classes
    absl::time
    internal_numa
    absl::memory
    internal_logging
    absl::numeric
    absl::hash
)

# ---- project: experiment -----
# sources
set(experiment_src
    tcmalloc/tcmalloc/experiment.cc
    tcmalloc/tcmalloc/experiment.h
    tcmalloc/tcmalloc/experiment_config.h
)
# project
add_library(experiment ${experiment_src})
# deps
target_link_libraries(experiment
    internal_logging
    internal_environment
    malloc_extension
    absl::strings
    absl::base
)

# ---- project: malloc_extension -----
# sources
set(malloc_extension_src
    tcmalloc/tcmalloc/internal_malloc_extension.h
    tcmalloc/tcmalloc/malloc_extension.cc
    tcmalloc/tcmalloc/malloc_extension.h
)
# project
add_library(malloc_extension ${malloc_extension_src})
# deps
#'malloc_extension' link libraries is empty
target_link_libraries(malloc_extension absl::base)

# ---- project: noruntime_size_classes -----
# sources
set(noruntime_size_classes_src
    tcmalloc/tcmalloc/noruntime_size_classes.cc
    tcmalloc/tcmalloc/runtime_size_classes.h
)
# project
add_library(noruntime_size_classes ${noruntime_size_classes_src})
# deps
target_link_libraries(noruntime_size_classes
    absl::strings
    absl::base
)

# ---- project: internal_environment -----
# sources
set(internal_environment_src
    tcmalloc/tcmalloc/internal/environment.cc
    tcmalloc/tcmalloc/internal/environment.h
)
# project
add_library(internal_environment ${internal_environment_src})
# deps
target_link_libraries(internal_environment
)

# ---- project: internal_logging -----
# sources
set(internal_logging_src
    tcmalloc/tcmalloc/internal/logging.cc
    tcmalloc/tcmalloc/internal/logging.h
)
# project
add_library(internal_logging ${internal_logging_src})
# deps
target_link_libraries(internal_logging
    absl::debugging
    absl::strings
    absl::base
    malloc_extension
)

# ---- project: internal_memory_stats -----
# sources
set(internal_memory_stats_src
    tcmalloc/tcmalloc/internal/memory_stats.cc
    tcmalloc/tcmalloc/internal/memory_stats.h
)
# project
add_library(internal_memory_stats ${internal_memory_stats_src})
# deps
target_link_libraries(internal_memory_stats
    internal_util
    absl::strings
    internal_logging
)

# ---- project: internal_mincore -----
# sources
set(internal_mincore_src
    tcmalloc/tcmalloc/internal/mincore.cc
    tcmalloc/tcmalloc/internal/mincore.h
)
# project
add_library(internal_mincore ${internal_mincore_src})
# deps
target_link_libraries(internal_mincore
)

# ---- project: internal_numa -----
# sources
set(internal_numa_src
    tcmalloc/tcmalloc/internal/numa.cc
    tcmalloc/tcmalloc/internal/numa.h
)
# project
add_library(internal_numa ${internal_numa_src})
# deps
target_link_libraries(internal_numa
    internal_percpu
    internal_logging
    internal_environment
    absl::strings
    internal_util
    absl::base
)

# ---- project: internal_percpu -----
# sources
set(internal_percpu_src
    tcmalloc/tcmalloc/internal/percpu.cc
    tcmalloc/tcmalloc/internal/percpu.h
    tcmalloc/tcmalloc/internal/percpu_rseq_asm.S
    tcmalloc/tcmalloc/internal/percpu_rseq_unsupported.cc
)
# project
add_library(internal_percpu ${internal_percpu_src})
# deps
target_link_libraries(internal_percpu
    internal_logging
    internal_util
    absl::base
)

# ---- project: internal_util -----
# sources
set(internal_util_src
    tcmalloc/tcmalloc/internal/util.cc
    tcmalloc/tcmalloc/internal/util.h
)
# project
add_library(internal_util ${internal_util_src})
# deps
target_link_libraries(internal_util
    internal_logging
    absl::base
    absl::time
    absl::span
)

if (TEST)
add_executable(tcmalloc_test_hello_main ${TCMALLOC_TEST_PATH}/hello_main.cc)
add_dependencies(tcmalloc_test_hello_main malloc_extension)
target_link_libraries(tcmalloc_test_hello_main
    tcmalloc
    malloc_extension
    absl::strings
    absl::str_format
    absl::base
    absl::optional
    absl::malloc_internal
    )
endif()
