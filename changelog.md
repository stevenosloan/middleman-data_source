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
