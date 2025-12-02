%module(directors="1") CspCommonVectors

%include "typemaps.i"
%include "carrays.i"

%{
#include "CSP/Common/Vector.h"
%}

/************************************************************
 * UNITY EXTENSIONS SECTION — ENABLED WITH:
 *   cmake -DENABLE_UNITY_EXTENSIONS=ON
 ************************************************************/
#ifdef SWIG_UNITY_EXTENSIONS

/* Remove arithmetic operators, since they conflict with Unity ones */
%ignore csp::common::Vector2::operator+;
%ignore csp::common::Vector2::operator-;
%ignore csp::common::Vector2::operator/;
%ignore csp::common::Vector2::operator*;

%ignore csp::common::Vector3::operator+;
%ignore csp::common::Vector3::operator-;
%ignore csp::common::Vector3::operator/;
%ignore csp::common::Vector3::operator*;

%ignore csp::common::Vector4::operator+;
%ignore csp::common::Vector4::operator-;
%ignore csp::common::Vector4::operator/;
%ignore csp::common::Vector4::operator*;

/* Add Unity extension converters */
%pragma(csharp) modulecode=%{
namespace Csp.UnityExtensions
{
    using UnityEngine;
    using Csp.Common;

    public static class VectorExtensions
    {
        // Vector2
        public static Vector2 ToUnity(this Vector2 v)
            => new Vector2(v.X, v.Y);

        public static Vector2 ToFoundation(this UnityEngine.Vector2 v)
            => new Vector2(v.x, v.y);

        // Vector3
        public static UnityEngine.Vector3 ToUnity(this Vector3 v)
            => new UnityEngine.Vector3(v.X, v.Y, v.Z);

        public static Vector3 ToFoundation(this UnityEngine.Vector3 v)
            => new Vector3(v.x, v.y, v.z);

        // Vector4
        public static UnityEngine.Vector4 ToUnity(this Vector4 v)
            => new UnityEngine.Vector4(v.X, v.Y, v.Z, v.W);

        public static Vector4 ToFoundation(this UnityEngine.Vector4 v)
            => new Vector4(v.x, v.y, v.z, v.w);
    }
}
%}

#endif  // SWIG_UNITY_EXTENSIONS

/************************************************************
 * NON-UNITY MODE — NORMAL SWIG OPERATOR EXPORT
 ************************************************************/
#ifndef SWIG_UNITY_EXTENSIONS

/* C# operator renames for arithmetic operators */
%feature("cs:operator", "+") csp::common::Vector2::operator+;
%feature("cs:operator", "-") csp::common::Vector2::operator-;
%feature("cs:operator", "*") csp::common::Vector2::operator*;
%feature("cs:operator", "/") csp::common::Vector2::operator/;

%feature("cs:operator", "+") csp::common::Vector3::operator+;
%feature("cs:operator", "-") csp::common::Vector3::operator-;
%feature("cs:operator", "*") csp::common::Vector3::operator*;
%feature("cs:operator", "/") csp::common::Vector3::operator/;

%feature("cs:operator", "+") csp::common::Vector4::operator+;
%feature("cs:operator", "-") csp::common::Vector4::operator-;
%feature("cs:operator", "*") csp::common::Vector4::operator*;
%feature("cs:operator", "/") csp::common::Vector4::operator/;

#endif

/* Now that all the rules are in place, start parsing the header applying them. */
%include "CSP/Common/Vector.h"
