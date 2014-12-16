set :environment,     :test
set :show_exceptions, false

activate :data_source do |c|

  c.root = File.join( Dir.pwd, 'remote_data1' )

  c.files = [
    'remote.json'
  ]

end

activate :data_source do |c|

  c.root = File.join( Dir.pwd, 'remote_data2' )

  c.files = [
    'in_yaml.yml'
  ]

end
