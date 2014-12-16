set :environment,     :test
set :show_exceptions, false

activate :data_source do |c|

  c.root = File.join( Dir.pwd, 'remote_data' )

  c.files = [
    'remote.json',
    'deeply/nested/routes.json',
    'in_yaml.yml',
    'in_json.json'
  ]

end
