namespace InteropTestsXUnit;

using csp.common;

public class OperatorsTest
{

    /*
     * Test that operators we map into specific functions do just that
     */
    [Fact]
    public void EqualsFromOperator()
    {
        ApplicationSettings applicationSettings1 = new ApplicationSettings();
        ApplicationSettings applicationSettings2 = new ApplicationSettings();

        Assert.True(applicationSettings1.Equals(applicationSettings2));
        Assert.True(applicationSettings2.Equals(applicationSettings1));

        applicationSettings2.ApplicationName = "RandomString";

        Assert.False(applicationSettings1.Equals(applicationSettings2));
        Assert.False(applicationSettings2.Equals(applicationSettings1));
    }

    [Fact]
    public void NotEqualsFromOperator()
    {
        // Bit weird exposing this, because you'd probably just do
        // !Equals(), but it is an operator in C++ that could technically
        // have different behavior (normally optimizations)

        ApplicationSettings applicationSettings1 = new ApplicationSettings();
        ApplicationSettings applicationSettings2 = new ApplicationSettings();

        Assert.False(applicationSettings1.NotEquals(applicationSettings2));
        Assert.False(applicationSettings2.NotEquals(applicationSettings2));

        applicationSettings2.ApplicationName = "RandomString";

        Assert.True(applicationSettings1.NotEquals(applicationSettings2));
        Assert.True(applicationSettings2.NotEquals(applicationSettings1));
    }


}
