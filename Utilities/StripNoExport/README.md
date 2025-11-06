This script runs on the include directory of the fetched CSP release during the generation step.

We strip out all CSP_NO_EXPORT declarations, as well as code between CSP_START_IGNORE and CSP_END_IGNORE. We could manually %ignore them, but that's a bother. It's a bit of a bad pattern CSP has chosen to use these macros, there are surely more standard ways of hiding implementation. Ideally this step would not exist.

You'll note the testdata, this is just a few files taken from CSP at time of writing to check the behaviour. Practically arbitrary.

The output for this dosen't have to be pretty, we just need the symbols gone. You'll note how we don't bother doing the logic
to delete the docs, since they're irrelevent. 