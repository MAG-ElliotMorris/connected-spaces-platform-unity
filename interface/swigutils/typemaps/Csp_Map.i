/* -----------------------------------------------------------------------------
 * THE BELOW IS BASED ON SWIGS ON map.i TYPEMAP
 * It shouldn't exist long term, it is a shim until we can expose standard
 * types properly in the interface.
 *
 * SWIG typemaps for csp::common::Map< K, T >
 *
 * The C# wrapper is made to look and feel like a C# System.Collections.Generic.IDictionary<>.
 *
 * Using this wrapper is fairly simple. For example, to create a map from integers to doubles use:
 *
 *   %include <std_map.i>
 *   %template(MapIntDouble) csp::common::Map<int, double>
 *
 * Notes:
 * 1) IEnumerable<> is implemented in the proxy class which is useful for using LINQ with
 *    C++ csp::common::Map wrappers.
 *
 * Warning: heavy macro usage in this file. Use swig -E to get a sane view on the real file contents!
 * ----------------------------------------------------------------------------- */

%{
#include <map>
#include <algorithm>
#include "CSP/Common/Map.h"
%}

/* K is the C++ key type, T is the C++ value type */
%define SWIG_STD_MAP_INTERNAL(K, T)

%typemap(csinterfaces) csp::common::Map< K, T > "global::System.IDisposable \n    , global::System.Collections.Generic.IDictionary<$typemap(cstype, K), $typemap(cstype, T)>\n"
%proxycode %{

  public $typemap(cstype, T) this[$typemap(cstype, K) key] {
    get {
      return getitem(key);
    }

    set {
      setitem(key, value);
    }
  }

  public bool TryGetValue($typemap(cstype, K) key, out $typemap(cstype, T) value) {
    if (this.ContainsKey(key)) {
      value = this[key];
      return true;
    }
    value = default($typemap(cstype, T));
    return false;
  }

  public bool IsEmpty {
    get {
      return Size() == 0;
    }
  }

  public int Count {
    get {
      return (int)Size();
    }
  }

  public bool IsReadOnly {
    get {
      return false;
    }
  }

  public global::System.Collections.Generic.ICollection<$typemap(cstype, K)> Keys {
    get {
      global::System.Collections.Generic.ICollection<$typemap(cstype, K)> keys = new global::System.Collections.Generic.List<$typemap(cstype, K)>();
      int size = this.Count;
      if (size > 0) {
        global::System.IntPtr iter = create_iterator_begin();
        for (int i = 0; i < size; i++) {
          keys.Add(get_next_key(iter));
        }
        destroy_iterator(iter);
      }
      return keys;
    }
  }

  public global::System.Collections.Generic.ICollection<$typemap(cstype, T)> Values {
    get {
      global::System.Collections.Generic.ICollection<$typemap(cstype, T)> vals = new global::System.Collections.Generic.List<$typemap(cstype, T)>();
      foreach (global::System.Collections.Generic.KeyValuePair<$typemap(cstype, K), $typemap(cstype, T)> pair in this) {
        vals.Add(pair.Value);
      }
      return vals;
    }
  }

  public void Add(global::System.Collections.Generic.KeyValuePair<$typemap(cstype, K), $typemap(cstype, T)> item) {
    Add(item.Key, item.Value);
  }

  public bool Remove(global::System.Collections.Generic.KeyValuePair<$typemap(cstype, K), $typemap(cstype, T)> item) {
    if (Contains(item)) {
      return Remove(item.Key);
    } else {
      return false;
    }
  }

  public bool Contains(global::System.Collections.Generic.KeyValuePair<$typemap(cstype, K), $typemap(cstype, T)> item) {
    if (!this.ContainsKey(item.Key))
    {
      return false;
    }
    
    if (this[item.Key] == item.Value) {
      return true;
    } else {
      return false;
    }
  }

  public void CopyTo(global::System.Collections.Generic.KeyValuePair<$typemap(cstype, K), $typemap(cstype, T)>[] array) {
    CopyTo(array, 0);
  }

  public void CopyTo(global::System.Collections.Generic.KeyValuePair<$typemap(cstype, K), $typemap(cstype, T)>[] array, int arrayIndex) {
    if (array == null)
      throw new global::System.ArgumentNullException("array");
    if (arrayIndex < 0)
      throw new global::System.ArgumentOutOfRangeException("arrayIndex", "Value is less than zero");
    if (array.Rank > 1)
      throw new global::System.ArgumentException("Multi dimensional array.", "array");
    if (arrayIndex+this.Count > array.Length)
      throw new global::System.ArgumentException("Number of elements to copy is too large.");

    global::System.Collections.Generic.IList<$typemap(cstype, K)> keyList = new global::System.Collections.Generic.List<$typemap(cstype, K)>(this.Keys);
    for (int i = 0; i < keyList.Count; i++) {
      $typemap(cstype, K) currentKey = keyList[i];
      array.SetValue(new global::System.Collections.Generic.KeyValuePair<$typemap(cstype, K), $typemap(cstype, T)>(currentKey, this[currentKey]), arrayIndex+i);
    }
  }

  global::System.Collections.Generic.IEnumerator<global::System.Collections.Generic.KeyValuePair<$typemap(cstype, K), $typemap(cstype, T)>> global::System.Collections.Generic.IEnumerable<global::System.Collections.Generic.KeyValuePair<$typemap(cstype, K), $typemap(cstype, T)>>.GetEnumerator() {
    return new $csclassnameEnumerator(this);
  }

  global::System.Collections.IEnumerator global::System.Collections.IEnumerable.GetEnumerator() {
    return new $csclassnameEnumerator(this);
  }

  public $csclassnameEnumerator GetEnumerator() {
    return new $csclassnameEnumerator(this);
  }

  // Type-safe enumerator
  /// Note that the IEnumerator documentation requires an InvalidOperationException to be thrown
  /// whenever the collection is modified. This has been done for changes in the size of the
  /// collection but not when one of the elements of the collection is modified as it is a bit
  /// tricky to detect unmanaged code that modifies the collection under our feet.
  public sealed class $csclassnameEnumerator : global::System.Collections.IEnumerator,
      global::System.Collections.Generic.IEnumerator<global::System.Collections.Generic.KeyValuePair<$typemap(cstype, K), $typemap(cstype, T)>>
  {
    private $csclassname collectionRef;
    private global::System.Collections.Generic.IList<$typemap(cstype, K)> keyCollection;
    private int currentIndex;
    private object currentObject;
    private int currentSize;

    public $csclassnameEnumerator($csclassname collection) {
      collectionRef = collection;
      keyCollection = new global::System.Collections.Generic.List<$typemap(cstype, K)>(collection.Keys);
      currentIndex = -1;
      currentObject = null;
      currentSize = collectionRef.Count;
    }

    // Type-safe iterator Current
    public global::System.Collections.Generic.KeyValuePair<$typemap(cstype, K), $typemap(cstype, T)> Current {
      get {
        if (currentIndex == -1)
          throw new global::System.InvalidOperationException("Enumeration not started.");
        if (currentIndex > currentSize - 1)
          throw new global::System.InvalidOperationException("Enumeration finished.");
        if (currentObject == null)
          throw new global::System.InvalidOperationException("Collection modified.");
        return (global::System.Collections.Generic.KeyValuePair<$typemap(cstype, K), $typemap(cstype, T)>)currentObject;
      }
    }

    // Type-unsafe IEnumerator.Current
    object global::System.Collections.IEnumerator.Current {
      get {
        return Current;
      }
    }

    public bool MoveNext() {
      int size = collectionRef.Count;
      bool moveOkay = (currentIndex+1 < size) && (size == currentSize);
      if (moveOkay) {
        currentIndex++;
        $typemap(cstype, K) currentKey = keyCollection[currentIndex];
        currentObject = new global::System.Collections.Generic.KeyValuePair<$typemap(cstype, K), $typemap(cstype, T)>(currentKey, collectionRef[currentKey]);
      } else {
        currentObject = null;
      }
      return moveOkay;
    }

    public void Reset() {
      currentIndex = -1;
      currentObject = null;
      if (collectionRef.Count != currentSize) {
        throw new global::System.InvalidOperationException("Collection modified.");
      }
    }

    public void Dispose() {
      currentIndex = -1;
      currentObject = null;
    }
  }

%}

  public:
    Map();
    Map(const Map& other);
    size_t Size() const;
    %rename(ContainsKey) HasKey;
    bool HasKey(const K& key);
    void Clear();
    %extend {
      const T& getitem(const K& key) throw (std::out_of_range) {
        csp::common::Map< K, T >::MapType::iterator iter = $self->Find(key);
        if (iter != $self->end())
          return iter->second;
        else
          throw std::out_of_range("key not found");
      }

      void setitem(const K& key, const T& x) {
        (*$self)[key] = x;
      }

      void Add(const K& key, const T& value) throw (std::out_of_range) {
        if ($self->HasKey(key))
          throw std::out_of_range("key already exists");
        (*$self)[key] = value;
      }

      bool Remove(const K& key) {
        if ($self->HasKey(key)) {
          $self->Remove(key);
          return true;
        }
        return false;
      }

      // create_iterator_begin(), get_next_key() and destroy_iterator work together to provide a collection of keys to C#
      %apply void *VOID_INT_PTR { csp::common::Map< K, T >::MapType::iterator *create_iterator_begin }
      %apply void *VOID_INT_PTR { csp::common::Map< K, T >::MapType::iterator *swigiterator }

      csp::common::Map< K, T >::MapType::iterator *create_iterator_begin() {
        return new csp::common::Map< K, T >::MapType::iterator($self->begin());
      }

      const K& get_next_key(csp::common::Map< K, T >::MapType::iterator *swigiterator) {
        (void)$self;
        csp::common::Map< K, T >::MapType::iterator iter = *swigiterator;
        (*swigiterator)++;
        return (*iter).first;
      }

      void destroy_iterator(csp::common::Map< K, T >::MapType::iterator *swigiterator) {
        (void)$self;
        delete swigiterator;
      }
    }


%enddef

%csmethodmodifiers csp::common::Map::empty "private"
%csmethodmodifiers csp::common::Map::size "private"
%csmethodmodifiers csp::common::Map::getitem "private"
%csmethodmodifiers csp::common::Map::setitem "private"
%csmethodmodifiers csp::common::Map::create_iterator_begin "private"
%csmethodmodifiers csp::common::Map::get_next_key "private"
%csmethodmodifiers csp::common::Map::destroy_iterator "private"

// Default implementation
namespace csp::common {
  template<class K, class T> class Map {
    SWIG_STD_MAP_INTERNAL(K, T)
  };
}