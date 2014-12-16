module Middleman
  module Fixture

    class << self

      def default env=:test
        Middleman::Application.server.inst do
          set :environment, env
        end
      end

      def app &block
        ENV['MM_ROOT'] = Given::TMP
        Middleman::Application.server.inst do
          instance_eval(&block) if block
        end
      end

    end

  end
end
