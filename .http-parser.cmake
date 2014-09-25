# Resource
set(HP "http-parser.2.3")

# Extract libuv
set(HP_DIR "${CMAKE_CURRENT_BINARY_DIR}/src/${HP}")
file(MAKE_DIRECTORY ${CMAKE_CURRENT_BINARY_DIR}/src)
execute_process(COMMAND ${CMAKE_COMMAND} -E tar xf ${CMAKE_CURRENT_LIST_DIR}/deps/${HP}.tar.gz WORKING_DIRECTORY ${CMAKE_CURRENT_BINARY_DIR}/src)

# Includes
set(HP_INCLUDE_DIRS "${HP_DIR}/include")

# OSX builds
if(APPLE)
  set(HP_LIB "${CMAKE_CURRENT_BINARY_DIR}/libuv.a")
  message("libuv: OSX")
  if(NOT EXISTS ${HP_LIB})

    # Clone gyp
    file(MAKE_DIRECTORY ${HP_DIR}/build)
    execute_process(COMMAND git clone https://git.chromium.org/external/gyp.git build/gyp WORKING_DIRECTORY ${HP_DIR})
    message("libuv: Gyp clone")

    # Gyp setup
    execute_process(COMMAND python ./gyp_uv.py -f xcode WORKING_DIRECTORY ${HP_DIR})
    message("libuv: Gyp setup")

    # Build
    execute_process(COMMAND xcodebuild -ARCHS="x86_64" -project uv.xcodeproj -configuration Release -target All WORKING_DIRECTORY ${HP_DIR})
    execute_process(COMMAND ${CMAKE_COMMAND} -E copy_if_different build/Release/libuv.a ${CMAKE_CURRENT_BINARY_DIR} WORKING_DIRECTORY ${HP_DIR})
    message("libuv: Build")
  endif()

  # Setup library
  add_library(uv UNKNOWN IMPORTED)
  set_property(TARGET uv PROPERTY IMPORTED_LOCATION ${CMAKE_CURRENT_BINARY_DIR}/libuv.a)
  set(HP_LIBRARIES uv)
  message("libuv: OK")
endif()
