# Project wide build options

include_guard(GLOBAL)

# This is a blessed option, CMake knows about it and sets defaults based on if you declare it or not.
option(BUILD_SHARED_LIBS "Build shared instead of static" ON)