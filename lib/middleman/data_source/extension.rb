module Middleman
  module DataSource

    class Extension < ::Middleman::Extension
      self.supports_multiple_instances = true

      option :rack_app,  nil, 'rack app to use'
      option :root,      nil, 'http(s) host to use'
      option :files,      [], 'routes to mount as remote data files'

      def rack_app
        @_rack_app ||= ::Rack::Test::Session.new( ::Rack::MockSession.new( options.rack_app ) )
      end

      def initialize app, options_hash={}, &block
        super app, options_hash, &block

        app_inst     = app.respond_to?(:inst) ? app.inst : app
        remote_datas = if options.files.respond_to? :keys
          options.files
        else
          Hash[options.files.map do |remote_file|
            [remote_file, remote_file]
          end]
        end

        remote_datas.each do |remote_file, local_representation|
          extension = File.extname remote_file
          parts     = local_representation.split(File::SEPARATOR)
          basename  = File.basename parts.pop, extension

          if parts.empty?
            original_callback = app_inst.data.callbacks[basename]
            app_inst.data.callbacks[basename] = Proc.new do
              attempt_merge_then_enhance decode_data(remote_file, extension), original_callback
            end
          else
            original_callback = app_inst.data.callbacks[parts.first]
            app_inst.data.callbacks[parts.first] = Proc.new do
              built_data = { basename => decode_data(remote_file, extension) }
              parts[1..-1].reverse.each do |part|
                built_data = { part => built_data }
              end

              attempt_merge_then_enhance built_data, original_callback
            end
          end
        end
      end

      private

        def attempt_merge_then_enhance new_data, original_callback
          if original_callback
            original_data = original_callback.call
            if original_data.respond_to? :merge
              return ::Middleman::Util.recursively_enhance original_data.deep_merge(new_data)
            end
          end

          return ::Middleman::Util.recursively_enhance new_data
        end

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
