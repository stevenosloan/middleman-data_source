module Middleman
  module DataSource

    class Extension < ::Middleman::Extension
    end
    ::Middleman::Extensions.register(:data_source, Middleman::DataSource::Extension)

  end
end
