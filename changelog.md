- add support for specifying file resources as a hash so you can do
  ```ruby
  c.files = {
    "/url/for/resource" => "data_key"
  }
  ```

# 0.1.0
- initial release supporting rack or borrower discovered assets parsed with YAML or JSON.
