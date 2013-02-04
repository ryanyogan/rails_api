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

      klass, action = get_controller_and_action env
      rack_app = klass.action action
      rack_app.call env
    end
  end
end
