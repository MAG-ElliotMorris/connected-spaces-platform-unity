namespace InteropTestsXUnit;

using csp.systems;
using csp.common;
using csp.multiplayer;
using csp;
using System.Drawing;
using System.Reflection;

public class OptionalTest : IDisposable
{
    /*
     * Test optional conversion
     * This one's a bit different, as whilst there _are_ underlying concrete Optional types,
     * the interface is expressed using C# `?` annotations. C# users won't see then.
     * 
     * A tad tricky to test in isolation as there arn't that many isolated Optional<T> interfaces
     * in CSP.
     */

    public void Dispose()
    {
        // Runs after each test, helps trigger some GC bugs earlier. Should probably put this in every test.
        GC.Collect();
        GC.WaitForPendingFinalizers();
        GC.Collect();
    }


    [Fact]
    public void OptionalProperty()
    {
        SequenceChangedNetworkEventData data = new SequenceChangedNetworkEventData();

        HotspotSequenceChangedNetworkEventData hotspotData = new HotspotSequenceChangedNetworkEventData();
        hotspotData.Name = "HotspotName";

        data.HotspotData = hotspotData;

        Assert.Equal(hotspotData.Name, data.HotspotData.Name);

        //hotspotdata and data.Hotspotdata are now different, a copy has occured
        hotspotData.Name = "NewName";
        Assert.Equal("NewName", hotspotData.Name);
        Assert.Equal("HotspotName", data.HotspotData.Name);

        //Disposing of hotspotdata shouldn't effect data.Hostpostdata
        hotspotData.Dispose();

        Assert.NotNull(data.HotspotData);
        Assert.Equal("HotspotName", data.HotspotData.Name);
    }

    [Fact]
    public void OptionalPropertyNoExternalPin()
    {
        // Test that when we set an optional property directly with = new T(), it's all good.
        SequenceChangedNetworkEventData data = new SequenceChangedNetworkEventData();
        data.HotspotData = new HotspotSequenceChangedNetworkEventData();

        //Force a GC here, just out of paranoia
        GC.Collect();
        GC.WaitForPendingFinalizers();
        GC.Collect();

        Assert.NotNull(data.HotspotData);

        data.HotspotData.Name = "NewName";
        Assert.Equal("NewName", data.HotspotData.Name);
    }

    [Fact]
    public void OptionalPropertyNullSet()
    {
        SequenceChangedNetworkEventData data = new SequenceChangedNetworkEventData();
        Assert.Null(data.HotspotData);

        HotspotSequenceChangedNetworkEventData hotspotData = null;
        data.HotspotData = hotspotData;

        Assert.Null(data.HotspotData);

        //Actually set something, then null it.
        data.HotspotData = new HotspotSequenceChangedNetworkEventData();
        data.HotspotData = null;

        Assert.Null(data.HotspotData);
    }

    [Fact]
    public void OptionalContainer()
    {
        //Initialise has an Optional<Array<FeatureFlag>> (FeatureFlagValueArray? in C#) interface that we can use to at least check the interface accepts the type.

        ClientUserAgent agent = new ClientUserAgent();
        FeatureFlagValueArray? OptArray = null;
        Assert.Null(OptArray);
        CSPFoundation.Initialise("", "", agent, OptArray);

        OptArray = new FeatureFlagValueArray(1);
        OptArray[0] = new FeatureFlag(EFeatureFlag.Invalid, true);
        Assert.Single(OptArray);
        Assert.NotNull(OptArray);

        OptArray = null;
        Assert.Null(OptArray);
    }

}
