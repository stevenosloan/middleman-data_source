set :environment,     :test
set :show_exceptions, false

activate :data_source do |c|

  c.rack_app = Rack::Builder.new do
                 use Rack::Static, urls: ["/"],
                                   root: "remote_data"
                 run lambda {|env| [404, {'Content-type' => 'text/plain'}, ['Not found']] }
              end

  c.files = [
    'remote.json',
    'deeply/nested.json',
    'deeply/nested/routes.json',
    'in_yaml.yml',
    'in_json.json'
  ]

end
