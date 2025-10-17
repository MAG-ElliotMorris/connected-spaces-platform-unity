# Fetch CSP. If CSP were cmake this would be hugely simplified and more robust.
# Windows only right now, making this cross platform is going to be a pain.

include_guard(GLOBAL)

# If we've set a CSP_ROOT_DIR ourselves, don't bother downloading, just use it
if(NOT DEFINED CSP_ROOT_DIR)
  set(CSP_ROOT_DIR "${_DEPS_DIR}/connected-spaces-platform" CACHE PATH "Root directory for CSP. If unset, CSP is automatically downloaded")

  # This is necessary to find the latest CSP release.
  # This dependency could be removed if CSP omitted the build number from its release naming.
  # Then we could pin to a CSP_RELEASE_NUMBER variable, and deduce the URL directly.
  find_program(GH_EXECUTABLE gh)
  if(NOT GH_EXECUTABLE)
      message(FATAL_ERROR "GitHub CLI (gh) not found. Please install it and retry. (https://cli.github.com/)")
  endif()

  # Download Latest CSP Release
  execute_process(
      COMMAND gh release download --repo magnopus-opensource/connected-spaces-platform --pattern *Win64*.zip --skip-existing --dir ${_DEPS_DIR}
      WORKING_DIRECTORY ${CMAKE_BINARY_DIR}
      RESULT_VARIABLE res
  )
  if(res)
      message(FATAL_ERROR "CSP Download failed with code ${res}")
      return()
  endif()

  # Unzip it (we don't know the precise name)
  file(GLOB _CSP_ZIP_FILES_LIST "${_DEPS_DIR}/*Win64*.zip")
  list(LENGTH _CSP_ZIP_FILES_LIST _CSP_ZIP_COUNT)
  if(NOT _CSP_ZIP_COUNT EQUAL 1)
      message(FATAL_ERROR "Could not find CSP zip file when unzipping")
  endif()

  # Cmake syntax eh, we're just using glob to find the file, but it's a list, should just be 1-big, get it.
  list(GET _CSP_ZIP_FILES_LIST 0 _CSP_ZIP_FILE)
  message("Unzipping ${_CSP_ZIP_FILE} to ${CSP_ROOT_DIR}")

  file(MAKE_DIRECTORY ${CSP_ROOT_DIR})
  execute_process(
      COMMAND ${CMAKE_COMMAND} -E tar xzf "${_CSP_ZIP_FILE}"
      WORKING_DIRECTORY ${CSP_ROOT_DIR}
  )

  # Argh! CSP zips its include dir for _some_ reason
  execute_process(
      COMMAND ${CMAKE_COMMAND} -E tar xzf "${CSP_ROOT_DIR}/include/include.zip"
      WORKING_DIRECTORY ${CSP_ROOT_DIR}/include
  )

elseif()
  message(STATUS "Using CSP_ROOT_DIR=${MYLIB_ROOT}, CSP download skipped.")
endif()

# Export a target
set(_CSP_INCLUDE_DIR "${CSP_ROOT_DIR}/include")
set(_CSP_LIB_DIR "${CSP_ROOT_DIR}/lib")

message(STATUS "CSP_ROOT_DIR='${CSP_ROOT_DIR}'")
message(STATUS "_CSP_INCLUDE_DIR='${_CSP_INCLUDE_DIR}'")

# Todo: Static on ios I expect
add_library(_CSP SHARED IMPORTED GLOBAL)
set_target_properties(_CSP PROPERTIES
    IMPORTED_IMPLIB_RELEASE "${_CSP_LIB_DIR}/ConnectedSpacesPlatform.lib"
    IMPORTED_IMPLIB_DEBUG "${_CSP_LIB_DIR}/ConnectedSpacesPlatform_D.lib"
    IMPORTED_LOCATION_RELEASE "${_CSP_LIB_DIR}/ConnectedSpacesPlatform.dll"
    IMPORTED_LOCATION_DEBUG "${_CSP_LIB_DIR}/ConnectedSpacesPlatform_D.dll"
    INTERFACE_INCLUDE_DIRECTORIES "${_CSP_INCLUDE_DIR}"
)


