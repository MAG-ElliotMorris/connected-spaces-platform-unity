%{
#include "CSP/Systems/WebService.h"
%}

%include "CSP/Systems/WebService.h"


/************************************************************
 * UNITY EXTENSIONS SECTION — ENABLED WITH:
 *   cmake -DENABLE_UNITY_EXTENSIONS=ON
 ************************************************************/
#ifdef SWIG_UNITY_EXTENSIONS

%extend csp::systems::ResultBase {
%proxycode %{
#region UNITY EXTENSIONS

        /// <summary>
        /// Throws a <seealso cref="FoundationEndpointException"/> if something went wrong. The exception contains the error code.
        /// </summary>
        /// <param name="callingMethodName"> The name of the method that called this extension method. It is used to help log the message of the exception if there is one. </param>
        /// <param name="handleDispose"> True if you want this function to call Dispose on the result object in case the event of throwing an exception.
        /// If you handle Dispose outside this function with a 'using' statement, you do not need to handle Dispose in this function. </param>
        public void ThrowIfNeeded(string callingMethodName, bool handleDispose = false)
        {
            if (this?.GetResultCode() != EResultCode.Success
                || this?.swigCPtr.Handle == System.IntPtr.Zero)
            {
                ushort statusCode = 500;
                string responseBody = null;
                ERequestFailureReason failureReason = 0;
                if (this != null)
                {
                    statusCode = this.GetHttpResultCode();
                    responseBody = this.GetResponseBody();
                    failureReason = this.GetFailureReason();
                    if (handleDispose)
                    {
                        this.Dispose();
                    }
                }

                // TODO: Handle FoundationEndpointException properly when available
                //throw new FoundationEndpointException($"{callingMethodName} failed.", statusCode, responseBody: responseBody, failureReason: failureReason);
            }
        }

#endregion
%}
}

#endif  // SWIG_UNITY_EXTENSIONS