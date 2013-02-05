require "nails/version"
require "nails/routing"
require "nails/util"
require "nails/dependencies"
require "nails/controller"
require "nails/file_model"

require "nails/array" # This doesn't do anything other than show "Monkey Patching"


module Nails
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
