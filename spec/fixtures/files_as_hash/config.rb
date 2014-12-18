set :environment,     :test
set :show_exceptions, false

activate :data_source do |c|

  c.root = File.join( Dir.pwd, 'remote_data' )

  c.files = {
    "/deeply/nested.json" => "mapped_nested",
    "/in_yaml.yml" => "mapped_in_yaml",
    "/in_json.json" => "mapped_in_json"
  }

end
