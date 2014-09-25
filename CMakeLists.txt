## Project
cmake_minimum_required(VERSION 2.8)
project(ruv)

# Library setup
file(GLOB_RECURSE SOURCES src/*.c)

# Flags
if(CMAKE_COMPILER_IS_GNUCC)
  set(CMAKE_C_FLAGS "-Wall -pedantic -Wimplicit-function-declaration -Wreturn-type -Wstrict-prototypes -Wextra")
  if(NOT WIN32)
    set(CMAKE_C_FLAGS "${CMAKE_C_FLAGS} -Werror")
  endif()
  set(CMAKE_C_FLAGS "${CMAKE_C_FLAGS} -std=c99")
endif()
if(APPLE)
  if("${CMAKE_OSX_ARCHITECTURES}" EQUAL "")
    message("Defaulting to i386 build on OSX")
    set(CMAKE_OSX_ARCHITECTURES "x86_64")
  endif()
endif()

# Depend on external libuv
include(".libuv.cmake")

# libary headers
include_directories(${CMAKE_CURRENT_SOURCE_DIR}/src)
message(${UV_INCLUDE_DIRS})
include_directories(${UV_INCLUDE_DIRS})

# Build library
add_library(ruv STATIC ${SOURCES})

# Tests
enable_testing()
file(GLOB_RECURSE TESTS tests/*.c)
foreach(TNAME ${TESTS})
  get_filename_component(TEXE ${TNAME} NAME_WE)
  add_executable(${TEXE} ${TNAME})
  target_link_libraries(${TEXE} ruv uv)
  add_test(${TNAME} ${TEXE})
endforeach()
