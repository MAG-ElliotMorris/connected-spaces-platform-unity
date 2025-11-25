# Project wide build options

include_guard(GLOBAL)

# This is a blessed option, CMake knows about it and sets defaults based on if you declare it or not.
option(BUILD_SHARED_LIBS "Build shared instead of static" ON)

option(TRIM_CSP_NO_EXPORTS "Invoke Utilities/StripNoExports to trim the NO_EXPORT sections of CSP headers when consuming a release" ON)
option(INIT_UNITY_TEST_PROJECT "Initialize the Unity test project with the latest generated classes and libraries for Unity integration tests" ON)