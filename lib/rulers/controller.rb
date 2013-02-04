# rulers/lib/rulers/controller.rb
require "erubis"

module Rulers
  class Controller
    attr_reader :env

    def initialize env
      @env = env
    end

    def render(view_name, lcoals = {})
      filename = File.join "app", "views",
        "#{view_name}.html.erb"
      template = File.read filename
      eruby = Erubis::Eruby.new(template)
      eruby.result locals.merge(env: env)
    end
  end
end
