module Middleman
  class Browser

    attr_reader :browser

    def initialize app
      app_on_rack = app.class.to_rack_app
      @browser    = ::Rack::Test::Session.new( ::Rack::MockSession.new(app_on_rack) )
    end

    def get path
      browser.get( URI.escape(path) ).body
    end

    def get_response path
      browser.get( URI.escape(path) )
    end

  end
end
