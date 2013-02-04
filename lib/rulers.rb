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
      controller    = klass.new env
      text          = controller.send action
      if controller.get_response
        st, hd, rs = controller.get_response.to_a
        [st, hd, [rs.body].flatten]
      else
        [200, {'Content-Type' => 'text/html'}, [text]]
      end 
    end
  end
end
