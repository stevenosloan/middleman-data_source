set :environment,     :test
set :show_exceptions, false

activate :data_source do |c|

  c.root = File.join( Dir.pwd, 'remote_data' )

  c.sources = [
    {
      alias: 'altered',
      path: 'zero_index_array.yaml',
      middleware: Proc.new { |data|
        data.map { |i| i + 1 }
      }
    }
  ]

end
