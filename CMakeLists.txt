cmake_minimum_required(VERSION 3.28)
project(MyProj)

set(_DEPS_DIR "${CMAKE_BINARY_DIR}/_deps")

include(FetchContent)
include(cmake/GetSwig.cmake)
include(cmake/GetCSP.cmake)

# Global configuration. This should have RelWithDebugInfo in it also, 
# but we don't have CSP libs for it yet. Impressed that CMake forced
# me to declare this. If you add it here, Cmake will tell you at least
# some of the places you need to update as errors.
set(CMAKE_CONFIGURATION_TYPES "Debug;Release" CACHE STRING "" FORCE)

# ---------------- SWIG Codegen ----------------
# Interface (.i) files
set(ROOT_I_DIR "${CMAKE_SOURCE_DIR}/interface" CACHE FILEPATH "Root include directory for all .i files.")
set(ROOT_I_FILE "${ROOT_I_DIR}/main.i" CACHE FILEPATH "Main SWIG .i entry point, should be in ROOT_I_DIR")

# Generated code output
set(_GEN_CPP_DIR "${CMAKE_BINARY_DIR}/generated/cpp")
set(_GEN_CS_DIR  "${CMAKE_BINARY_DIR}/generated/cs")

# SWIG module/DLL name. This is the actual library you'd link against the use the API (whist _this_ library links against CSP proper)
set(_WRAPPER_MODULE_NAME "ConnectedSpacesPlatform_Unity_SWIG")
set(_CPP_WRAPPER_OUT "${_GEN_CPP_DIR}/${_WRAPPER_MODULE_NAME}_wrap.cxx")

message(STATUS "_GEN_CPP_DIR='${_GEN_CPP_DIR}'")
message(STATUS "_GEN_CS_DIR='${_GEN_CS_DIR}'")
message(STATUS "_WRAPPER_MODULE_NAME='${_WRAPPER_MODULE_NAME}'")
message(STATUS "_CPP_WRAPPER_OUT='${_CPP_WRAPPER_OUT}'")
message(STATUS "ROOT_I_FILE='${ROOT_I_FILE}'")

#It's annoying, SWIG does not remove the generated dir even if it should be changing things in it.
add_custom_target(CleanGen ALL
    COMMAND ${CMAKE_COMMAND} -E remove_directory "${_GEN_CPP_DIR}"
    COMMAND ${CMAKE_COMMAND} -E remove_directory "${_GEN_CS_DIR}"
)

# Setup SWIG invocation
add_custom_command(
  OUTPUT "${_CPP_WRAPPER_OUT}"
  COMMAND "${CMAKE_COMMAND}" -E make_directory "${_GEN_CPP_DIR}" "${_GEN_CS_DIR}"
  COMMAND "${SWIG_EXE}"
          -I${_CSP_INCLUDE_DIR} # So we can #include CSP's .h files.
          -I${ROOT_I_DIR} # So we can %include our own .i files.
          -c++ -csharp
          -module ${_WRAPPER_MODULE_NAME}
          -dllimport ${_WRAPPER_MODULE_NAME}
          -outdir "${_GEN_CS_DIR}"
          -o "${_CPP_WRAPPER_OUT}"
          -v # Still could be verboser ... There's other options if you need them
          "${ROOT_I_FILE}"
  DEPENDS "${ROOT_I_FILE}"
  WORKING_DIRECTORY "${CMAKE_CURRENT_SOURCE_DIR}" 
  VERBATIM
)

# ---------------- Build SWIG Output ----------------
add_library(${_WRAPPER_MODULE_NAME} SHARED "${_CPP_WRAPPER_OUT}")
set_target_properties(${_WRAPPER_MODULE_NAME} PROPERTIES
  CXX_STANDARD 17
  CXX_STANDARD_REQUIRED YES
  POSITION_INDEPENDENT_CODE ON
  OUTPUT_NAME "${_WRAPPER_MODULE_NAME}" # ConnectedSpacesPlatform.dll/libConnectedSpacesPlatform.so
)

# Add CSP Target to our output library, this produces a final API that can use CSP.
target_link_libraries(${_WRAPPER_MODULE_NAME} PRIVATE _CSP)

include(cmake/PackageInstall.cmake)