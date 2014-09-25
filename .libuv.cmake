# Resource
set(UV "libuv-0.11.29")

# Extract libuv
set(UV_DIR "${CMAKE_CURRENT_BINARY_DIR}/src/${UV}")
file(MAKE_DIRECTORY ${CMAKE_CURRENT_BINARY_DIR}/src)
execute_process(COMMAND ${CMAKE_COMMAND} -E tar xf ${CMAKE_CURRENT_LIST_DIR}/deps/${UV}.tar.gz WORKING_DIRECTORY ${CMAKE_CURRENT_BINARY_DIR}/src)

# Includes
set(UV_INCLUDE_DIRS "${UV_DIR}/include")

# OSX builds
if(APPLE)
  set(UV_LIB "${CMAKE_CURRENT_BINARY_DIR}/libuv.a")
  message("libuv: OSX")
  if(NOT EXISTS ${UV_LIB})

    # Clone gyp
    file(MAKE_DIRECTORY ${UV_DIR}/build)
    execute_process(COMMAND git clone https://git.chromium.org/external/gyp.git build/gyp WORKING_DIRECTORY ${UV_DIR})
    message("libuv: Gyp clone")

    # Gyp setup
    execute_process(COMMAND python ./gyp_uv.py -f xcode WORKING_DIRECTORY ${UV_DIR})
    message("libuv: Gyp setup")

    # Build
    execute_process(COMMAND xcodebuild -ARCHS="x86_64" -project uv.xcodeproj -configuration Release -target All WORKING_DIRECTORY ${UV_DIR})
    execute_process(COMMAND ${CMAKE_COMMAND} -E copy_if_different build/Release/libuv.a ${CMAKE_CURRENT_BINARY_DIR} WORKING_DIRECTORY ${UV_DIR})
    message("libuv: Build")
  endif()

  # Setup library
  add_library(uv UNKNOWN IMPORTED)
  set_property(TARGET uv PROPERTY IMPORTED_LOCATION ${CMAKE_CURRENT_BINARY_DIR}/libuv.a)
  set(UV_LIBRARIES uv)
  message("libuv: OK")
endif()
