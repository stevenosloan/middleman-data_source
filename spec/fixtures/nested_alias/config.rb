set :environment,     :test
set :show_exceptions, false

activate :data_source do |c|

  c.root = File.join( Dir.pwd, 'remote_data' )

  c.files = {
    'nested.json' => 'mounted/remote'
  }

  c.sources = [
    {
      alias: 'mounted',
      path: 'nested.json'
    }
  ]

end
