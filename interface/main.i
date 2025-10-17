/* Important to enable directors for anything that has callbacks, as that's the special 
 * SWIG magic that lets client code be called from inside C++.
 * The module name here should match the standard base name of the .dll
 */
%module(directors="1") ConnectedSpacesPlatform

/* Undefine all the CSP annotation macros so we have a chance of parsing the api naturally */
%include "swigutils/macrozapper.i"

/* Declare the api */
%include "Systems/SystemBase.i"
