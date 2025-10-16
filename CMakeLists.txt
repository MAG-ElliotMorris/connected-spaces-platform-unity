cmake_minimum_required(VERSION 3.18)
project(MyProj)

set(_DEPS_DIR "${CMAKE_BINARY_DIR}/_deps")

include(FetchContent)
include(cmake/GetSwig.cmake)
include(cmake/GetCSP.cmake)

