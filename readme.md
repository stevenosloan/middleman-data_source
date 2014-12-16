```ruby
activate :data_source do |c|
  c.root  = "http://localhost:8000" # can be an http or rack app
  c.files = [
    "some.yaml",
    "paths/js.json"
  ]
end
```



# Testing

```bash
$ rspec
```


# Contributing

If there is any thing you'd like to contribute or fix, please:

- Fork the repo
- Add tests for any new functionality
- Make your changes
- Verify all existing tests work properly
- Make a pull request


# License

The middleman-data_source gem is distributed under the [MIT License](/LICENSE).
