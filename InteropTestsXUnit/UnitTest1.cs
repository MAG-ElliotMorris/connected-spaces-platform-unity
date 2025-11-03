namespace InteropTestsXUnit;

using Csp;
using System.Diagnostics;

public class UnitTest1
{
    [Fact]
    public void Test1()
    {
        //This is a temporary test just to assert linking works, it's meaningless.
        MaintenanceInfo info = new MaintenanceInfo();
        Assert.False(info.IsInsideWindow());
    }

    [Fact]
    public void TestLog()
    {
        LogSystem logSystem = new LogSystem();
        Assert.True(logSystem != null);

        LogLevel? capturedLevel = null;
        string? capturedMessage = null;

        ConnectedSpacesPlatformDotNet.LogCallback callback = new ConnectedSpacesPlatformDotNet.LogCallback((logLevel, message) =>
        {
            capturedLevel = logLevel;
            capturedMessage = message;
        });

        logSystem.SetLogCallback(callback);
        logSystem.LogMsg(LogLevel.Log, "The first wrapped function works!");

        Assert.Equal(LogLevel.Log, capturedLevel);
        Assert.Equal("The first wrapped function works!", capturedMessage);
    }
}
