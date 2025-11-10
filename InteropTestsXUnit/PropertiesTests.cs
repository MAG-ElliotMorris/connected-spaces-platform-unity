namespace InteropTestsXUnit;

using Csp;

public class PropertiesTests

{
    /*
     * Test strings, which are typemapped from csp::common::String
     * (They should be typemapped from std::string, which will come after we can remove compatability shims)
     */
    [Fact]
    public void PropertyGetSet()
    {
        // EndpointURIs has value properties of service defintions,
        // providing us a decent place to test get/sets
        Csp.EndpointURIs endpointUris = new EndpointURIs();

        ServiceDefinition testMultiplayerServiceDefinition = new ServiceDefinition("http://fake-service.com", 1);

        // Test defaults (these are set in cpp constructor)
        Assert.Equal("", endpointUris.MultiplayerService.GetURI());
        Assert.Equal(0, endpointUris.MultiplayerService.GetVersion());

        endpointUris.MultiplayerService = testMultiplayerServiceDefinition;

        // This dosen't work because equality operators arn't implemented, poor form. https://github.com/MAG-ElliotMorris/connected-spaces-platform-unity/issues/4
        // Assert(endpointUris.MultiplayerService == testMultiplayerServiceDefinition);

        Assert.Equal("http://fake-service.com", endpointUris.MultiplayerService.GetURI());
        Assert.Equal(1, endpointUris.MultiplayerService.GetVersion());
    }

}
