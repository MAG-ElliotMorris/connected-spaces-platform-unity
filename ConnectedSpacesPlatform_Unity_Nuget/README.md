# Nuget Package

This csproj packages the build SWIG library into a nuget project.
You can do this by running `dotnet pack -c Release`

It depends on the project having already been built and installed into the `install` directory in the parent directory, which is the standard location if you run the cmake configure/build/install triplet.