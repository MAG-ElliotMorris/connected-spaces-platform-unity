# Fetch SWIG from our fork. Windows only at the moment

include_guard(GLOBAL)

# If SWIG_EXE has been set by the user, don't bother with all this download malarkey.
if(SWIG_EXE)
  message(STATUS "Using user-provided SWIG: ${SWIG_EXE}")
  return()
endif()

# The URL for the swig release zip, cmake will extract and use this for you.
# Expects the release format from the custom Magnopus IL2CPP fork.
set(SWIG_RELEASE_URL  "https://github.com/MAG-ElliotMorris/swig-il2cpp-directors/releases/download/0.0.1/swig-windows-cmake.zip")

set(_DEPS_DIR "${CMAKE_BINARY_DIR}/_deps")
set(_SWIG_ZIP      "${_DEPS_DIR}/swig-il2cpp-directors.zip")
set(_SWIG_BINARY_DIR "${CMAKE_CURRENT_BINARY_DIR}/_deps/swig-il2cpp-directors")

# Make the "_deps" dir (The same default FetchContent uses), to perform the swig extraction.
file(MAKE_DIRECTORY "${_DEPS_DIR}")

# Perform the SWIG binary download.
file(DOWNLOAD "${SWIG_RELEASE_URL}" "${_SWIG_ZIP}" SHOW_PROGRESS)

# Extract the SWIG binary.
file(ARCHIVE_EXTRACT INPUT "${_SWIG_ZIP}" DESTINATION "${_SWIG_BINARY_DIR}")

# Setup environment for usage of the SWIG executable, may be configured it you want to use a different SWIG.
set(SWIG_EXE "${_SWIG_BINARY_DIR}/bin/swig.exe" CACHE FILEPATH "Path to swig.exe, if not set, automatically fetched.")
message(STATUS "Using swig.exe: ${SWIG_EXE}")