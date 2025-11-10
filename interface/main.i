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



/* Declare the api */

/* CSP/ */
%include "CSP/CSPFoundation.i"

/* CSP/Common/Interfaces */


/* CSP/Systems*/
%include "CSP/Systems/SystemBase.i"

%include "CSP/Common/Systems/Log/LogSystem.i"
%include "CSP/Common/Systems/Log/LogLevels.i"

/* CSP/Multiplayer */




