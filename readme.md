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

### Custom data types

By default we just look at the extension of a file to determine which decoder to use. By setting a source directly you can give it any data type you need. Each source is a hash with an `alias`, `path`, and `type` key. The `alias` and `path` would be the same as if you defined the source using files as `{ path => alias }`, while type corresponds to the decoder you'd like to use.

There are default decoders for `:yaml` and `:json`, however you are free to override them or create your own types.

```ruby
# config.rb
activate :data_source do |c|

  c.files = ['by_extension.ctype']

  c.sources = [
    {
      alias: "foo_bar",
      path: "/foo/bar.ctype",
      type: :my_type
    }
  ]

  c.decoders = {
    my_type: {
      extensions: ['.ctype'],
      decoder: ->(src) { CustomType.parse(src) }
    }
  }
```

In the above example, I can access `app.data.by_extension` w/ the file contents decoded by `CustomType`, because it's extension `.ctype` matches the one defined by the `:my_type` decoder. Similarly, `app.data.foo_bar` is also run through `CustomType` because it's `:type` attribute is set to `:my_type`.


### Creating a collection

Collections allow you to collection sources that have belong together in an array and have distinct urls. This would loosely follow the Rails index/show convension. For example, lets say we have an endpoint that tells us about some Game of Thrones characters, and then includes a single endpoint for each with expanded information:

```json
# /got/index.json
[
  { "name": "Eddard Stark", "url": "/got/eddard-stark.json" },
  { "name": "Hodor", "url": "/got/hodor.json" }
]
```

```json
# /got/eddard-stark.json
{
  "name": "Eddard Stark",
  "quote": "Winter is coming"
}

#/got/hodor.json
{
  "name": "Hodor",
  "quote": "Hodor!"
}
```

Then set up a collection to access them through Middleman. A collection requires 3 keys, an `alias`, `path`, and `items`. The alias & path act just like a source, except that data will be available at `#{alias}.#{index}`. Items should be an object that responds to `#call` and returns an array of sources when given the data from the collection index. A collection for our example API:

```ruby
activate :data_source do |c|
  c.root = 'http://winteriscoming.com'
  c.collection = {
    alias: 'got_chars',
    path: '/got/index.json',
    index: 'all',
    items: Proc.new { |data|
      data.map do |char|
        {
          alias: char['name'].to_slug,
          path: char['url']
        }
      end
    }
  }
end
```

You'll see I've used a proc to map our index into sources. The information is then accessible via the data object:

```ruby
data.got_chars.all.map(&:name)
# => ['Eddard Stark', 'Hodor']

data.got_chars['eddard-stark'].quote
# => Winter is coming
```

For index_name, you can also pass `false` to not generate the index data.


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
