require File.expand_path( "../lib/middleman/data_source/version", __FILE__ )

Gem::Specification.new do |s|

  s.name          = 'middleman-data_source'
  s.version       = Middleman::DataSource::VERSION
  s.platform      = Gem::Platform::RUBY

  s.summary       = 'Allow for loading data in middleman from remote sources'
  s.description   = %q{ Allow for loading data in middleman from remote sources }
  s.authors       = ["Steven Sloan"]
  s.email         = "stevenosloan@gmail.com"
  s.homepage      = "http://github.com/stevenosloan/middleman-data_source"
  s.license       = "MIT"

  s.files         = Dir[ "{doc,lib}/**/*", "readme.md", "changelog.md" ]
  s.test_files    = Dir["spec/**/*.rb"]
  s.require_path  = "lib"

  # Utility
  s.add_dependency "middleman", ["~> 3.1"]

end
