require "ray/version"
require "ray/routing"
require "ray/array"

module Ray
  class Application
    def call(env)
      if env["PATH_INFO"] == "/favicon.ico"
        return [404, { "Content-Type" => "text/html" }, []]
      end

      klass, action = get_controller_and_action(env)
      controller = klass.new(env)
      text = controller.send(action)

      [
        200,
        { "Content-Type" => "text/html" },
        [text]
      ]
    end
  end

  class Controller
    def initialize(env)
      @env = env
    end

    def env
      @env
    end
  end
end
