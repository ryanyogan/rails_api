# rulers/lib/rulers/controller.rb
require "erubis"
require "rulers/file_model"

module Rulers
  class Controller
    include Rulers::Model
    attr_reader :env

    def initialize env
      @env = env
    end

    # Let's cache the result here if it doesn't
    # exist
    def request
      @request ||= Rack::Request.new @env
    end

    def response(text, status = 200, headers = {})
      raise "Already responded!" if @response
      a = [text].flatten
      @response = Rack::Response.new(a, status, headers)
    end

    def get_response # Internal use only
      @response # attr_reader would make more sense
    end

    def render_response(*args)
      response(render(*args))
    end

    # Thanks to Rack, we now have a parsed out 
    # environment hash, hence we can extrapolate 
    # "rails like" params very easily
    def params
      request.params
    end

    def controller_name
      klass = self.class
      klass = klass.to_s.gsub /Controller$/, ""
      Rulers.to_underscore klass
    end

    def render(view_name, locals = {})
      filename = File.join "app", "views",
        controller_name, "#{view_name}.html.erb"
      template = File.read filename
      eruby = Erubis::Eruby.new(template)
      eruby.result locals.merge(env: env)
    end
  end
end
