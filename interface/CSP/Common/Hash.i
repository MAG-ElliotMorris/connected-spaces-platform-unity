%{
#include "CSP/Common/Hash.h"
%}

/* Do not %include Hash.h - it only contains std::hash template specializations
 * which are internal C++ implementation details. SWIG doesn't need to parse these
 * (and warns about "Specialization of non-template 'hash'" if it does).
 * The %{ %} block above ensures the wrapper code can compile against the hash functions. */
