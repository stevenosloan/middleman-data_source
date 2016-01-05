set :environment,     :test
set :show_exceptions, false


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


activate :data_source do |c|

  c.root = File.join( Dir.pwd, 'remote_data' )

  c.collection = {
    alias: 'extensionless',
    path: 'extensionless/foo',
    type: :json,
    items: Proc.new { |d| [] }
  }

end

