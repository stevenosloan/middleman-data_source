
begin
  require 'middleman-core/rack'
rescue LoadError
end


module Middleman
  module Fixture

    class << self

      def app &block
        ENV['MM_ROOT'] = Given::TMP

        if Middleman::Application.respond_to?(:server)
          app = Middleman::Application.server.inst do
            instance_eval(&block) if block
          end
        else
          require 'middleman-core/renderers/sass'
          app = Middleman::Application.new do
            instance_eval(&block) if block
          end
        end

        app
      end

    end

  end
end
