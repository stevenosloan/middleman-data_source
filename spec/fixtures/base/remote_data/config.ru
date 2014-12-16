require 'rack'

use Rack::Static, urls: ["/"]
run lambda {|env| [404, {'Content-type' => 'text/plain'}, ['Not found']] }
