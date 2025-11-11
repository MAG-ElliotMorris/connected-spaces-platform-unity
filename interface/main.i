/* Important to enable directors for anything that has callbacks, as that's the special 
 * SWIG magic that lets client code be called from inside C++.
 * The module name here should match the standard base name of the .dll */
%module(directors="1") ConnectedSpacesPlatform

/* Undefine all the CSP annotation macros so we have a chance of parsing the api naturally */
%include "swigutils/MacroZapper.i"

/* Enable void* mapping. See "Void pointers" section : https://www.swig.org/Doc4.1/CSharp.html */
%apply void *VOID_INT_PTR { void * }

%include "typemaps.i"
%include "stdint.i"
%include "enums.swg"
%include "swigutils/typemaps/Csp_String.i"


%include "swigutils/CallbackAdapters.i"
%include "swigutils/AsyncAdapters.i"


/* CSP non-exported symbols */
%ignore ToJson;


/* Declare the api */

/* CSP/ */
%include "CSP/CSPFoundation.i"

/* CSP/Common */
%include "CSP/Common/CancellationToken.i"
%include "CSP/Common/LoginState.i"


/* CSP/Common/Interfaces */

/* CSP/Common/Systems/Log */
%include "CSP/Common/Systems/Log/LogSystem.i"
%include "CSP/Common/Systems/Log/LogLevels.i"

/* CSP/Systems*/
%include "CSP/Systems/SystemBase.i"


/* CSP/Multiplayer */




