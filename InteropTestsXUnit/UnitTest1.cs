namespace InteropTestsXUnit;

using Csp;

public class UnitTest1
{
    [Fact]
    public void Test1()
    {
        //This is a temporary test just to assert linking works, it's meaningless.
        MaintenanceInfo info = new MaintenanceInfo();
        Assert.False(info.IsInsideWindow());
    }
}
