Allows mounting of remote JSON & YAML to the [Middleman](http://middlemanapp.com) `data` object.

# Use

With Rubygems

```bash
$ gem install middleman-data_source
```

With Bundler

```ruby
gem 'middleman-data_source'
```

Then in your [Middleman](http://middlemanapp.com)'s `config.rb`

```ruby
activate :data_source do |c|
  c.root  = "http://yourdatahost.com"
  c.files = [
    "some.yaml",
    "paths/js.json"
  ]
end
```

And access them like any other data:

```ruby
# source/index.html

= data.some.title
```

You can also specify data resources as a hash to map the name:

```ruby
# config.rb (in data_source activation block)
c.files = {
  "/url/to/resource.json" => "my_resource"
}

# source/index.html
= data.my_resource
```

You can fetch your data in two ways:
1. from the file system or web with [Borrower](http://github.com/stevenosloan/borrower)
2. with a rack app

Multiple instances of the extension are supported, so activate once for each data source you require.


### With Borrower

Borrower provides a common interface for fetching files from the filesystem or through http, so it's configured the same either way. You'll specify your `root`, then the files you want loaded (with paths relative to root).

```ruby
# config.rb

activate :data_source do |c|
  c.root = '/var/data'
  c.files = [
    'middleman.json' # will look for this file at /var/data/middleman.json
                     # and be accessible through data.middleman
  ]
end

activate :data_source do |c|
  c.root = "http://yourhost.com"
  c.files = [
    'middleman.json' # will look for the file at http://yourhost.com/middleman.json
                     # and be accessible through data.middleman
  ]
```

### With a Rack App

We can also fetch data through a local rack app, so if you want to manipulate a database and mount the data you can. A simple example that just uses Rack::Static would look like this:

```ruby
# config.rb

activate :data_source do |c|

  c.rack_app = Rack::Builder.new do
                 use Rack::Static, urls: ["/"],
                                   root: "remote_data"
                 run lambda {|env| [404, {'Content-type' => 'text/plain'}, ['Not found']] }
              end

  c.files = [
    'rack.json' # passes /rack.json to your rack app
                # and mounts the data to data.rack
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

The `middleman-data_source` gem is distributed under the [MIT License](/LICENSE).
