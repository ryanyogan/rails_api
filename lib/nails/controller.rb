# lib/nails/controller.rb
require "erubis"
require "nails/file_model"

module Nails
  class Controller
    include Nails::Model
    attr_reader :env

    def initialize env
      @env = env
      @routing_params = {}
    end

    # This is a poor mans ActionDispatch similar to rails
    # this is going to pass any additional paramters, crazy uri's
    # etc... 
    def dispatch(action, routing_params = {})
      @routing_params = routing_params
      text = self.send action
      if get_response
        status, header, response = get_response.to_a
        [status, header, [response].flatten]
      else
        [200, {'Content-Type' => 'text/html'},
         [text].flatten]
      end
    end

    # We need to pass a proc object back to the rack router, we build it
    # in side this method, notice we call dispatch with the action and
    # request paramaters /:id, etc..
    def self.action(action, routing_params = {})
      proc { |e| self.new(e).dispatch(action, routing_params) }
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
      request.params.merge @routing_params
    end

    def controller_name
      klass = self.class
      klass = klass.to_s.gsub /Controller$/, ""
      Nails.to_underscore klass
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
