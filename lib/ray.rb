require "ray/version"
require "ray/routing"
require "ray/util"
require "ray/dependencies"
require "ray/controller"
require "ray/view"
require "ray/file_model"

module Ray
  class Application
    def call(env)
      if env["PATH_INFO"] == "/favicon.ico"
        return [404, { "Content-Type" => "text/html" }, []]
      end

      rack_app = get_rack_app(env)
      rack_app.call(env)
    end
  end
end
