require "rulers/version"
require "rulers/routing"
require "rulers/array"


module Rulers
  class Application
    def call(env)
      if env["PATH_INFO"] == '/favicon.ico'
        return [404,
                {'Content-Type' => 'text/html'}, []]
      end

      klass, act = get_controller_and_action(env)
      controller = klass.new(env)
      begin
        text = controller.send(act)
        [200, {'Content-Type' => 'text/html'},
         [text]]
      rescue 
        [500, {'Content-Type' => 'text/html'},
         ["Oh crap, something broke! Look at the stack trace."]]
      end
    end
  end

  class Controller
    attr_reader :env

    def initialize(env)
      @env = env
    end

  end
end
