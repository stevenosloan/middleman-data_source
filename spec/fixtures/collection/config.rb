set :environment,     :test
set :show_exceptions, false

# base collection spec
activate :data_source do |c|

  c.root = File.join( Dir.pwd, 'remote_data' )

  c.collection = {
    alias: 'root',
    path: 'root.json',
    items: Proc.new { |data|
      data.map do |d|
        {
          alias: d['slug'],
          path: File.join('root', "#{d['slug']}.json")
        }
      end
    }
  }

end

# extensionless
activate :data_source do |c|

  c.root = File.join( Dir.pwd, 'remote_data' )

  c.collection = {
    alias: 'extensionless',
    path: 'extensionless/foo',
    type: :json,
    items: Proc.new { |d| [] }
  }

end

# custom index key
activate :data_source do |c|

  c.root = File.join( Dir.pwd, 'remote_data' )

  c.collection = {
    alias: 'custom_index',
    index: 'dem_things',
    path: 'custom_index/index.yaml',
    items: Proc.new { |d| [] }
  }

end

# no index key
activate :data_source do |c|

  c.root = File.join( Dir.pwd, 'remote_data' )

  c.collection = {
    alias: 'no_index',
    index: false,
    path: 'no_index/index.yaml',
    items: Proc.new { |d| [{ alias: 'data',
                             path: 'no_index/index.yaml' }] }
  }

end
