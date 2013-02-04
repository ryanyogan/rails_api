require "rulers/version"
require "rulers/routing"
require "rulers/util"
require "rulers/dependencies"
require "rulers/controller"
require "rulers/file_model"

require "rulers/array"


module Rulers
  class Application
    def call(env)
      if env["PATH_INFO"] == '/favicon.ico' || env["PATH_INFO"] == '/'
        return [404,
                {'Content-Type' => 'text/html'}, []]
      end

      klass, act = get_controller_and_action(env)
      controller = klass.new(env)
      begin
        p env
        text = controller.send(act)
        [200, {'Content-Type' => 'text/html'},
         [text]]
      rescue RuntimeError => e
        [500, {'Content-Type' => 'text/html'},
         ["Oh crap, something broke! Look at the stack trace.\n #{e}"]]
      end
    end
  end
end
