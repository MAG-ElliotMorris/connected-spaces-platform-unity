namespace InteropTestsXUnit;

using csp.systems;

public class UnitTest1
{
    [Fact]
    public void Test1()
    {
        //This is a temporary test just to assert linking works, it's meaningless.
        SystemBase systemBase = new SystemBase(0, false);
        // Calling anything will fail because SystemBase is a base type and cant be instantiated
        Assert.True(true);
    }
}
