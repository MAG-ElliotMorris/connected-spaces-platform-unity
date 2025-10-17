# ---------------- Package / Install ----------------

# In the future, this might want to produce something friendlier for CSharp,
# currently it ships the necessary .dll/.so's, as well as the .cs files that serve as includes.
# I'm not totally sure about the ecosystem. Do you ship .csproj files?

set(INSTALL_DIR "${CMAKE_SOURCE_DIR}/install" CACHE FILEPATH "Directory to install output .cs and shared libraries")

# Remove the install dir at install time so old artifacts don't hang around
install(CODE "
  file(REMOVE_RECURSE \"${INSTALL_DIR}\")
")

# Primary install of the generated wrapper binary
install(
  TARGETS ${_WRAPPER_MODULE_NAME}
  RUNTIME DESTINATION "${INSTALL_DIR}/bin" # .exe / .dll on Windows
  LIBRARY DESTINATION "${INSTALL_DIR}/lib" # .so / .dylib on Unix
  ARCHIVE DESTINATION "${INSTALL_DIR}/lib" # .lib static import libraries
)

# Install debug symbols of the wrapper binary in addition
install(
  FILES $<TARGET_PDB_FILE:${_WRAPPER_MODULE_NAME}>
  DESTINATION "${INSTALL_DIR}/bin"
  CONFIGURATIONS Debug RelWithDebInfo #RelWithDebInfo doesn't exist, but it'll want to be here when it does.
)

# /cs generated dir, the files you actually work with in Csharp.
install(
  DIRECTORY "${_GEN_CS_DIR}/"
  DESTINATION "${INSTALL_DIR}/include"
)

# The actual underlying CSP library, needs to sit alongside the bindings.
# Including this makes this a complete artifact.
install(
  FILES $<TARGET_FILE:_CSP>
  DESTINATION ${INSTALL_DIR}/bin
)

# Finally the underlying CSP's debug symbols on windows platforms (no pdb equivalent on unix).
# TARGET_PDB_FILE is not available for imported targets (why though?)
# So do it more explicitly.
if(MSVC)
  install(FILES "${_CSP_LIB_DIR}/ConnectedSpacesPlatform_D.pdb"
          DESTINATION "${INSTALL_DIR}/bin"
          CONFIGURATIONS Debug)

  install(FILES "${_CSP_LIB_DIR}/ConnectedSpacesPlatform.pdb"
          DESTINATION "${INSTALL_DIR}/bin"
          CONFIGURATIONS RelWithDebInfo)
endif()