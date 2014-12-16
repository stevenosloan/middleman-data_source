module Middleman
  module DataSource

    class Extension < ::Middleman::Extension

      option :rack_app,  nil, 'rack app to use'
      option :root,      nil, 'http(s) host to use'
      option :files,      [], 'routes to mount as remote data files'

      def rack_app
        @_rack_app ||= ::Rack::Test::Session.new( ::Rack::MockSession.new( options.rack_app ) )
      end

      def after_configuration
        options.files.each do |remote_file|
          extension = File.extname  remote_file
          basename  = File.basename remote_file, extension

          app.data.callbacks[basename] = Proc.new do
            ::Middleman::Util.recursively_enhance(decode_data(remote_file, extension))
          end
        end
      end

      private

        def decode_data file_path, extension
          if ['.yaml', '.yml'].include? extension
            YAML.load get_file_contents file_path
          elsif extension == '.json'
            ActiveSupport::JSON.decode get_file_contents file_path
          else
            raise UnsupportedDataExtension
          end
        end

        def get_file_contents file_path
          if options.rack_app
            rack_app.get( URI.escape(file_path) ).body
          else
            Borrower::Content.get File.join( options.root, file_path )
          end
        end

      class UnsupportedDataExtension < ArgumentError
      end

    end
    ::Middleman::Extensions.register(:data_source, Middleman::DataSource::Extension)

  end
end
