module Middleman
  module DataSource

    class Extension < ::Middleman::Extension
      self.supports_multiple_instances = true

      option :rack_app,  nil, 'rack app to use'
      option :root,      nil, 'http(s) host or file path to use'
      option :files,      [], 'routes to mount as remote data files'
      option :sources,    [], 'array of sources to mount as data'
      option :decoders,   {}, 'callable functions to decode data sources'
      option :collection, {}, 'group of recursive resources'

      attr_reader :decoders, :sources, :collection,
                  :app_inst

      def rack_app
        @_rack_app ||= ::Rack::Test::Session.new( ::Rack::MockSession.new( options.rack_app ) )
      end

      def initialize app, options_hash={}, &block
        super app, options_hash, &block
        @app_inst = app.respond_to?(:inst) ? app.inst : app

        @sources    = options.sources.dup + convert_files_to_sources(options.files)
        @decoders   = default_decoders.merge(options.decoders)

        if options.collection.empty?
          @collection = false
        else
          @collection = options.collection
          sources.push options.collection.merge alias: File.join( options.collection[:alias], 'all' )
        end

        sources.each do |source|
          add_data_callback_for_source(source)
        end

        if collection
          collection[:items].call( app_inst.data[collection[:alias]]['all'] ).map do |source|
            source[:alias] = File.join(collection[:alias], source[:alias])
            source
          end.each do |source|
            add_data_callback_for_source(source)
          end
        end
      end

      private

        def add_data_callback_for_source source
          raw_extension = File.extname(source[:path])
          extension     = raw_extension.split('?').first
          parts         = source[:alias].split(File::SEPARATOR)
          basename      = File.basename(parts.pop, raw_extension)

          if parts.empty?
            original_callback = app_inst.data.callbacks[basename]
            app_inst.data.callbacks[basename] = Proc.new do
              attempt_merge_then_enhance decode_data(source, extension), original_callback
            end
          else
            original_callback = app_inst.data.callbacks[parts.first]
            app_inst.data.callbacks[parts.first] = Proc.new do
              begin
                built_data = { basename => decode_data(source, extension) }
                parts[1..-1].reverse.each do |part|
                  built_data = { part => built_data }
                end

                attempt_merge_then_enhance built_data, original_callback
              rescue => e
                binding.pry
              end
            end
          end
        end

        def convert_files_to_sources files={}
          files.flat_map do |remote_path, local|
            {
              alias: (local || remote_path),
              path: remote_path
            }
          end
        end

        def default_decoders
          {
            json: {
              extensions: ['.json'],
              decoder:    ->(source) { JSON.parse(source) },
            },
            yaml: {
              extensions: ['.yaml', '.yml'],
              decoder:    ->(source) { YAML.load(source) }
            }
          }
        end

        def attempt_merge_then_enhance new_data, original_callback
          if original_callback
            original_data = original_callback.call
            if original_data.respond_to? :deep_merge
              return ::Middleman::Util.recursively_enhance original_data.deep_merge(new_data)
            elsif original_data.respond_to? :merge
              return ::Middleman::Util.recursively_enhance deep_merge(original_data, new_data)
            end
          end

          return ::Middleman::Util.recursively_enhance new_data
        end

        def decode_data source, extension
          if source.has_key? :type
            decoder = decoders[source[:type]]
          else
            decoder = decoders.find do |candidate|
              candidate[1][:extensions].include? extension
            end
            decoder = decoder.last if decoder
          end

          raise UnsupportedDataExtension unless decoder

          decoder[:decoder].call get_file_contents source[:path]
        end

        def get_file_contents file_path
          if options.rack_app
            rack_app.get( URI.escape(file_path) ).body
          else
            file_path = File.join( options.root, file_path ) if options.root
            Borrower::Content.get file_path
          end
        end

        def deep_merge base, extension
          base.merge extension do |key, old_val, new_val|
            old_val = old_val.to_hash if old_val.respond_to?(:to_hash)
            new_val = new_val.to_hash if new_val.respond_to?(:to_hash)

            if old_val.respond_to?(:merge) && new_val.respond_to?(:merge)
              deep_merge old_val, new_val
            else
              new_val
            end
          end
        end

      class UnsupportedDataExtension < ArgumentError
      end

    end
    ::Middleman::Extensions.register(:data_source, Middleman::DataSource::Extension)

  end
end
