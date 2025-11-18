namespace InteropTestsXUnit;

using Csp;

public class MapTests
{
    /* We use StringDict to test this - it's a csp::common::Map<String, String> exposed to C#.
     * The point of this test is to test the Map typemap from csp::common::Map -> C# IDictionary
     * This whole test suite should go away once we migrate away from the CSP common types, this
     * is sort of redundant work just to support a migration :(
     */

    [Fact]
    public void NewMapIsEmptyAndWriteable()
    {
        var map = new StringDict();
        Assert.False(map.IsReadOnly);
        Assert.Equal(0, map.Count);
        Assert.Empty(map);
    }

    [Fact]
    public void MapWithItemsHasCorrectCount()
    {
        var map = new StringDict();
        map.Add("key1", "value1");
        map.Add("key2", "value2");
        map.Add("key3", "value3");

        Assert.Equal(3, map.Count);
        Assert.False(map.IsEmpty);
    }

    [Fact]
    public void AddAndRetrieveItems()
    {
        var map = new StringDict();
        map.Add("firstName", "Elliot");
        map.Add("lastName", "Morris");

        Assert.Equal("Elliot", map["firstName"]);
        Assert.Equal("Morris", map["lastName"]);
    }

    [Fact]
    public void AddKeyValuePair()
    {
        var map = new StringDict();
        var kvp = new KeyValuePair<string, string>("key", "value");

        map.Add(kvp);

        Assert.Single(map);
        Assert.Equal("value", map["key"]);
    }

    [Fact]
    public void AddDuplicateKeyThrows()
    {
        var map = new StringDict();
        map.Add("key", "value1");

        Assert.Throws<ArgumentOutOfRangeException>(() => map.Add("key", "value2"));
    }

    [Fact]
    public void GetNonExistentKeyThrows()
    {
        var map = new StringDict();
        map.Add("key", "value");

        Assert.Throws<ArgumentOutOfRangeException>(() => map["nonExistentKey"]);
    }

    [Fact]
    public void CopyConstructor()
    {
        var map1 = new StringDict();
        map1.Add("key1", "value1");
        map1.Add("key2", "value2");

        var map2 = new StringDict(map1);

        Assert.Equal(2, map2.Count);
        Assert.Equal("value1", map2["key1"]);
        Assert.Equal("value2", map2["key2"]);

        // Verify they are independent copies
        map1.Add("key3", "value3");
        Assert.Equal(3, map1.Count);
        Assert.Equal(2, map2.Count);
        Assert.False(map2.ContainsKey("key3"));
    }

    [Fact]
    public void TryGetValue()
    {
        var map = new StringDict();
        map.Add("key", "value");

        Assert.True(map.TryGetValue("key", out var retrievedValue));
        Assert.Equal("value", retrievedValue);

        Assert.False(map.TryGetValue("nonExistentKey", out var notFoundValue));
        Assert.Null(notFoundValue);
    }

    [Fact]
    public void IndexerSetUpdatesExistingValue()
    {
        var map = new StringDict();
        map.Add("key", "oldValue");
        Assert.Equal("oldValue", map["key"]);

        map["key"] = "newValue";
        Assert.Equal("newValue", map["key"]);
        Assert.Single(map); // Should still be only one element in the map
    }

    [Fact]
    public void IndexerSetAddsNewKey()
    {
        var map = new StringDict();
        map["newKey"] = "newValue";

        Assert.Equal("newValue", map["newKey"]);
        Assert.Single(map);
    }

    [Fact]
    public void ContainsKey()
    {
        var map = new StringDict();
        map.Add("existingKey", "value");

        Assert.True(map.ContainsKey("existingKey"));
        Assert.False(map.ContainsKey("nonExistentKey"));
    }


    [Fact]
    public void ContainsKeyValuePair()
    {
        var map = new StringDict();
        map.Add("key1", "value1");

        var kvp = new KeyValuePair<string, string>("key1", "value1");
        Assert.True(map.Contains(kvp));

        var wrongValueKvp = new KeyValuePair<string, string>("key1", "wrongValue");
        Assert.False(map.Contains(wrongValueKvp));

        var nonExistentKvp = new KeyValuePair<string, string>("key2", "value2");
        Assert.False(map.Contains(nonExistentKvp));
    }

    [Fact]
    public void RemoveByKey()
    {
        var map = new StringDict();
        map.Add("TeamMember1", "Elliot Morris");
        map.Add("TeamMember2", "Alessio Regalbuto");

        Assert.True(map.Remove("TeamMember1"));
        Assert.Single(map);
        Assert.False(map.ContainsKey("TeamMember1"));
        Assert.True(map.ContainsKey("TeamMember2"));

        // Removing non-existent key returns false
        Assert.False(map.Remove("TeamMember1"));
    }

    [Fact]
    public void RemoveByKeyValuePair()
    {
        var map = new StringDict();
        map.Add("TeamMember1", "Elliot Morris");
        map.Add("TeamMember2", "Alessio Regalbuto");

        var kvp = new KeyValuePair<string, string>("TeamMember2", "Alessio Regalbuto");
        Assert.True(map.Remove(kvp));
        Assert.Equal(1, map.Count);
        Assert.False(map.ContainsKey("TeamMember2"));
        Assert.True(map.ContainsKey("TeamMember1"));
    }

    [Fact]
    public void RemoveByKeyValuePairWithWrongValue()
    {
        var map = new StringDict();
        map.Add("key1", "value1");

        var kvp = new KeyValuePair<string, string>("key1", "wrongValue");
        Assert.False(map.Remove(kvp));
        Assert.Single(map);
        Assert.True(map.ContainsKey("key1"));
    }

    [Fact]
    public void ClearRemovesAllItems()
    {
        var map = new StringDict();
        map.Add("key1", "value1");
        map.Add("key2", "value2");
        map.Add("key3", "value3");

        Assert.Equal(3, map.Count);

        map.Clear();

        Assert.Empty(map);
        Assert.True(map.IsEmpty);
        Assert.Empty(map);
    }

    [Fact]
    public void KeysCollection()
    {
        var map = new StringDict();
        map.Add("key1", "value1");
        map.Add("key2", "value2");
        map.Add("key3", "value3");

        var keys = map.Keys;
        Assert.Equal(3, keys.Count);
        Assert.Contains("key1", keys);
        Assert.Contains("key2", keys);
        Assert.Contains("key3", keys);
    }

    [Fact]
    public void ValuesCollection()
    {
        var map = new StringDict();
        map.Add("key1", "value1");
        map.Add("key2", "value2");
        map.Add("key3", "value3");

        var values = map.Values;
        Assert.Equal(3, values.Count);
        Assert.Contains("value1", values);
        Assert.Contains("value2", values);
        Assert.Contains("value3", values);
    }


    [Fact]
    public void CopyToArrayHappyPath()
    {
        var map = new StringDict();
        map.Add("key1", "value1");
        map.Add("key2", "value2");
        map.Add("key3", "value3");

        var array = new KeyValuePair<string, string>[3];
        map.CopyTo(array, 0);

        Assert.Equal(3, array.Length);
        Assert.Contains(new KeyValuePair<string, string>("key1", "value1"), array);
        Assert.Contains(new KeyValuePair<string, string>("key2", "value2"), array);
        Assert.Contains(new KeyValuePair<string, string>("key3", "value3"), array);
    }

    [Fact]
    public void PatialCopyTo()
    {
        var map = new StringDict();
        map.Add("key1", "value1");
        map.Add("key2", "value2");
        map.Add("key3", "value3");
        map.Add("key4", "value4");
        map.Add("key5", "value5");

        var array = new KeyValuePair<string, string>[7];
        // Copy element 3 onwards, [0] and [1] will have null values
        map.CopyTo(array, 2);

        Assert.Equal(7, array.Length);
        Assert.Null(array[0].Key);
        Assert.Null(array[1].Key);
        Assert.Equal("key1", array[2].Key);
        Assert.Equal("key2", array[3].Key);
        Assert.Equal("key3", array[4].Key);
        Assert.Equal("key4", array[5].Key);
        Assert.Equal("key5", array[6].Key);
    }

    [Fact]
    public void CopyToArrayExceptions()
    {
        var map = new StringDict();
        map.Add("key1", "value1");
        map.Add("key2", "value2");

        var array = new KeyValuePair<string, string>[5];

        // Null array
        Assert.Throws<ArgumentNullException>(() => map.CopyTo(null, 0));

        // Negative index
        Assert.Throws<ArgumentOutOfRangeException>(() => map.CopyTo(array, -1));

        // Not enough space
        Assert.Throws<ArgumentException>(() => map.CopyTo(array, 4));
    }


    [Fact]
    public void EnumeratorTest()
    {
        var map = new StringDict();
        map.Add("0", "value1");
        map.Add("1", "value2");
        map.Add("2", "value3");

        using (var e = map.GetEnumerator())
        {
            int count = 0;
            while (e.MoveNext())
            {
                Assert.Equal(count.ToString(), e.Current.Key);
                count++;
            }
            Assert.Equal(3, count); // Verify we enumerated all 3 items
        }
    }

    [Fact]
    public void LinqSmokeTest()
    {
        /*
         * Just test some Linq to make sure it's available
         */

        var map = new StringDict();
        map.Add("1", "one");
        map.Add("2", "two");
        map.Add("3", "three");
        map.Add("4", "four");
        map.Add("5", "five");

        var filtered = map.Where(kvp => kvp.Key == "2" || kvp.Key == "4");
        Assert.Equal(2, filtered.Count());

        var keys = filtered.Select(kvp => kvp.Key).ToList();
        Assert.Contains("2", keys);
        Assert.Contains("4", keys);
    }
}
