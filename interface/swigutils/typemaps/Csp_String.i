/* Adapted from the std_string.i typemape SWIG ships
 * https://github.com/swig/swig/blob/master/Lib/csharp/std_string.i 
 * Hopefully temporary, we don't want to keep using these interop types. */
%{
#include "CSP/Common/String.h"
%}


%naturalvar String;

class String;

// string
%typemap(ctype) String "const char *"
%typemap(imtype) String "string"
%typemap(cstype) String "string"

%typemap(csdirectorin) String "$iminput"
%typemap(csdirectorout) String "$cscall"

%typemap(in, canthrow=1) String 
%{ if (!$input) {
    SWIG_CSharpSetPendingExceptionArgument(SWIG_CSharpArgumentNullException, "null string", 0);
    return $null;
   }
   $1 = $input; %}
%typemap(out) String %{ $result = SWIG_csharp_string_callback($1.c_str()); %}

%typemap(directorout, canthrow=1) String 
%{ if (!$input) {
    SWIG_CSharpSetPendingExceptionArgument(SWIG_CSharpArgumentNullException, "null string", 0);
    return $null;
   }
   $result = $input; %}

%typemap(directorin) String %{ $input = $1.c_str(); %}

%typemap(csin) String "$csinput"
%typemap(csout, excode=SWIGEXCODE) String {
    string ret = $imcall;$excode
    return ret;
  }

%typemap(typecheck) String = char *;

%typemap(throws, canthrow=1) String
%{ SWIG_CSharpSetPendingException(SWIG_CSharpApplicationException, $1.c_str());
   return $null; %}

// const string &
%typemap(ctype) const String & "const char *"
%typemap(imtype) const String & "string"
%typemap(cstype) const String & "string"

%typemap(csdirectorin) const String & "$iminput"
%typemap(csdirectorout) const String & "$cscall"

%typemap(in, canthrow=1) const String &
%{ if (!$input) {
    SWIG_CSharpSetPendingExceptionArgument(SWIG_CSharpArgumentNullException, "null string", 0);
    return $null;
   }
   $*1_ltype $1_str($input);
   $1 = &$1_str; %}
%typemap(out) const String & %{ $result = SWIG_csharp_string_callback($1->c_str()); %}

%typemap(csin) const String & "$csinput"
%typemap(csout, excode=SWIGEXCODE) const String & {
    string ret = $imcall;$excode
    return ret;
  }

%typemap(directorout, canthrow=1, warning=SWIGWARN_TYPEMAP_THREAD_UNSAFE_MSG) const String &
%{ if (!$input) {
    SWIG_CSharpSetPendingExceptionArgument(SWIG_CSharpArgumentNullException, "null string", 0);
    return $null;
   }
   /* possible thread/reentrant code problem */
   static $*1_ltype $1_str;
   $1_str = $input;
   $result = &$1_str; %}

%typemap(directorin) const String & %{ $input = $1.c_str(); %}

%typemap(csvarin, excode=SWIGEXCODE2) const String & %{
    set {
      $imcall;$excode
    } %}
%typemap(csvarout, excode=SWIGEXCODE2) const String & %{
    get {
      string ret = $imcall;$excode
      return ret;
    } %}

%typemap(typecheck) const String & = char *;

%typemap(throws, canthrow=1) const String &
%{ SWIG_CSharpSetPendingException(SWIG_CSharpApplicationException, $1.c_str());
   return $null; %}

