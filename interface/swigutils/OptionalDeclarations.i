/*
 * Enable nullable reference type annotations for generated C# code
 * Important because we want to use `?` syntax for all Optional<T>
 * interfaces, and the CSharp compiler will warn otherwise.
 * (This is all legacy from C#8 allowing nullable reference types finally)
 * You can do this as a project level setting, but doing it like this means consumers don't need to care.
 */
%typemap(csimports) SWIGTYPE %{
#nullable enable
%}

/* 
 * Call the typemap macros to declare all the optional types the api expresses
 * Reference types (classes) and value types (Nullable<T>) are handled differently,
 * with value types using .HasValue() and .Value(), in the interop layer, whilst
 * reference types just use `null` (? is merely an annotation). This is because
 * value types are implicitly convertible to Nullable<T>.
 * From the c# users perspective, everything looks like T? in the interface.
 *
 * You should include this before general api declaration
 */


#define SWIG_STD_OPTIONAL_DEFAULT_TYPES // Get the default arithmetical optionals, ints, doubles, etc.
#define SWIG_STD_OPTIONAL_USE_NULLABLE_REFERENCE_TYPES // Allow optional reference types (>C#8.0)

%include "swigutils/typemaps/Csp_Optional.i"

%optional(csp::common::Array<csp::FeatureFlag>)
%optional(csp::common::HotspotSequenceChangedNetworkEventData)