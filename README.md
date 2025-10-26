
## Building

To build, run the a standard configure/build/install CMake triplet from the root directory.

```bash
cmake -S . -B build
cmake --build build --config Debug
cmake --install build --config Debug
```

Building on Android/iOS is a little more involved, you can see specific invocations in the actions files. (Desktop, Android, iOS)

This should produce you an `install` directory with `bin`, `lib` and `include`subdirectories (dependent on platform).

### Installing to Unity
To use the install output in unity, copy the files like so:
- The contents of the `include` directory -> `Assets/Csp/Runtime/`
- Copy both binary files (`ConnectedSpacesPlatform` and `ConnectedSpacesPlatform_Unity_SWIG`) to the platform specific folder under `Assets/Plugins`
    - Windows: `Assets/Plugins/x86_64`
    - iOS : `Assets/Plugins/iOS`
    - Android: `Assets/Plugins/Android/arm64-v8a`
    - MacOS: `Assets/Plugins/macOS`

### Dependencies
- [CMake](https://cmake.org/): Version 3.28 or greater 
- [Github CLI](https://cli.github.com/): You must have the github command line tools installed and activated in order to discover and download the latest CSP release.
- (For Android) [Android NDK](https://developer.android.com/ndk/downloads): Tested with specific version `29.0.14206865`, but most should work.  

### Relevant CMake Variables

| Var | Type | Description |
|----------|----------|----------|
| `BUILD_SHARED_LIBS`| Boolean | Whether to produce shared .dlls/.dylibs/.so's, or static .lib/.a's. |
| `CMAKE_BUILD_TYPE` | "Debug" or "Release" | What type of build to produce. |
| `INSTALL_DIR`| Path | Where the `install` command places the final package. Defaults to `./install` |
| `CSHARP_CSP_NAMESPACE`| String | What to call the namespace generated Csp code is namespaced under. Defaults to "Csp" |
| `ROOT_I_DIR`| Path | Directory where the root `.i` SWIG interface file can be found. Defaults to `./interface`. The root `.i` file should be called `main.i` |
| `CSP_ROOT_DIR` | Path | Path to the root directory of a CSP release. Include directories are used in SWIG `.i` files, and provided binaries are linked against. This is normally downloaded automatically, and will be set by default to `BUILD_FOLDER/_deps/connected-spaces-platform` |
| `SWIG_EXE`| Path | Path to the directory containing the swig executable that is used to generate .cpp and .cs code. This is normally downloaded automatically, and will be set by default to `BUILD_FOLDER/_deps/swig-il2cpp-directors/bin/swig` |
