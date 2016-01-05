# 0.7.1
- allow passing data type to collection
- fix access to data object in middleman 3.x code branches

# 0.7.0 [YANKED]
- feat(collection): create a collection type that can generate a collection of resources based off of an index endpoint. [more info](readme.md#creating-a-collection)
- stop using `ActiveSupport::JSON` to parse json, this causes dates to no longer be decoded. To restore the original behavior, add a custom decoder for json.

# 0.6.1
- fixes for newer versions of middleman 4 compatability

# 0.6.0
- add definable decoders & allow override of default json & yaml decoders
- allow for defining sources with arbitrary data types

# 0.5.0
- include support for resources that include query params after their file extension [@jordanandree]

# 0.4.0
- add specs & support for middleman v4

# 0.3.0
- add support for using remote data imediatly after activating the extension

# 0.2.0
- add support for specifying file resources as a hash so you can do
  ```ruby
  c.files = {
    "/url/for/resource" => "data_key"
  }
  ```

# 0.1.0
- initial release supporting rack or borrower discovered assets parsed with YAML or JSON.
