namespace InteropTestsXUnit;

using Csp;
using Microsoft.Diagnostics.NETCore.Client;
using System.Diagnostics;
using System.IO;


public class CallbackTests
{
    [Fact]
    public void Callbacks()
    {
        /* Test that our callback adaptations function
         * We test 2 here, because we have a static buffer under the hood (swig IL2CPP adaptation), so 
         * it's possible state could be getting mangled. */
        LogSystem logSystem = new LogSystem();
        Assert.True(logSystem != null);

        LogLevel? capturedLevel1 = null;
        string? capturedMessage1 = null;

        ConnectedSpacesPlatformDotNet.LogCallback callback1 = new ConnectedSpacesPlatformDotNet.LogCallback((logLevel, message) =>
        {
            capturedLevel1 = logLevel;
            capturedMessage1 = message;
        });

        logSystem.SetLogCallback(callback1);
        logSystem.LogMsg(LogLevel.Log, "The first wrapped function works!");

        Assert.Equal(LogLevel.Log, capturedLevel1);
        Assert.Equal("The first wrapped function works!", capturedMessage1);

        LogLevel? capturedLevel2 = null;
        string? capturedMessage2 = null;

        ConnectedSpacesPlatformDotNet.LogCallback callback2 = new ConnectedSpacesPlatformDotNet.LogCallback((logLevel, message) =>
        {
            capturedLevel2 = logLevel;
            capturedMessage2 = message;
        });


        logSystem.SetLogCallback(callback2);
        logSystem.LogMsg(LogLevel.Warning, "The second wrapped function works!");

        Assert.Equal(LogLevel.Warning, capturedLevel2);
        Assert.Equal("The second wrapped function works!", capturedMessage2);
    }

    [Fact]
    public void CallbacksAcrossMultipleObjects()
    {
        /* Just a bit of paranoia really, no reason to believe this wouldn't work.
         * You can delete this if you like, once the initial integration is complete */

        LogSystem logSystem1 = new LogSystem();
        Assert.True(logSystem1 != null);
        LogSystem logSystem2 = new LogSystem();
        Assert.True(logSystem2 != null);

        LogLevel? capturedLevel = null;
        string? capturedMessage = null;
        int timesCalled = 0;

        ConnectedSpacesPlatformDotNet.LogCallback callback1 = new ConnectedSpacesPlatformDotNet.LogCallback((logLevel, message) =>
        {
            capturedLevel = logLevel;
            capturedMessage = message;
            timesCalled++;
        });

        logSystem1.SetLogCallback(callback1);
        logSystem2.SetLogCallback(callback1);

        logSystem1.LogMsg(LogLevel.Log, "First call.");

        Assert.Equal(LogLevel.Log, capturedLevel);
        Assert.Equal("First call.", capturedMessage);
        Assert.Equal(1, timesCalled);

        logSystem2.LogMsg(LogLevel.Warning, "Second call.");

        Assert.Equal(LogLevel.Warning, capturedLevel);
        Assert.Equal("Second call.", capturedMessage);
        Assert.Equal(2, timesCalled);
    }

    [Fact]
    public void CallbackSurvivesGCInSameFrame()
    {
        LogSystem logSystem = new LogSystem();

        LogLevel? capturedLevel = null;
        string? capturedMessage = null;

        logSystem.SetLogCallback(new ConnectedSpacesPlatformDotNet.LogCallback((logLevel, message) =>
        {
            capturedLevel = logLevel;
            capturedMessage = message;
        }));

        // Try as hard as we can to get the GC to collect unreferenced objects
        GC.Collect();
        GC.WaitForPendingFinalizers();
        GC.Collect();

        // I actually don't fully understand why the `new ConnectedSpacesPlatformDotNet.LogCallback` isn't GC'd.
        // It holds the delegate, and is held only in a WeakReference in a dict.
        // (well, also a HandleRef for the scope of the P/Invoke call)
        logSystem.LogMsg(LogLevel.Log, "Still works after GC?");
        Assert.Equal(LogLevel.Log, capturedLevel);
        Assert.Equal("Still works after GC?", capturedMessage);

    }
}
