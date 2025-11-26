# Path to the folder of the Unity project where the generated CSP code and libs will be copied to.
# 1 - Build the path safely
cmake_path(APPEND CSP_LIB_UNITY_DIR
    "${CMAKE_BINARY_DIR}"
    ".."
    "UnityProject"
    "CspUnityTests"
    "Assets"
    "Plugins"
    "CSP"
)
# 2 - Cache the result
set(CSP_LIB_UNITY_DIR "${CSP_LIB_UNITY_DIR}"
    CACHE PATH "Path to Unity CSP plugin directory"
)

# The asmdef file that will be used to establish the build settings for the generated CSP code and libs
# 1 - Build the path safely
cmake_path(APPEND _tmp_asmdef_path
    "${CMAKE_BINARY_DIR}"
    ".."
    "UnityProject"
    "ConnectedSpacesPlatform.Unity.Core.asmdef"
)
# 2 - Cache the result
set(CSP_ASMDEF_PATH "${_tmp_asmdef_path}"
    CACHE FILEPATH "Path to ConnectedSpacesPlatform Unity .asmdef file"
)

message(STATUS "CSP_LIB_UNITY_DIR='${CSP_LIB_UNITY_DIR}'")
message(STATUS "CSP_ASMDEF_PATH='${CSP_ASMDEF_PATH}'")

#
# Run these operations during install:
#   cmake --install build --config Debug
#
install(CODE "
    message(\"Deleting previous Unity generated code and libraries...\")
    file(REMOVE_RECURSE \"${CSP_LIB_UNITY_DIR}\")

    message(\"Creating required Unity folders...\")
    file(MAKE_DIRECTORY \"${CSP_LIB_UNITY_DIR}\")

    message(\"Copying CSP binary files to Unity...\")
    file(COPY \"${INSTALL_DIR}/\" DESTINATION \"${CSP_LIB_UNITY_DIR}\")

    message(\"Copying asmdef into CSP plugin folder...\")
    file(COPY \"${CSP_ASMDEF_PATH}\" DESTINATION \"${CSP_LIB_UNITY_DIR}/include/\")
")