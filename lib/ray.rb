require "ray/version"
require "ray/routing"
require "ray/util"
require "ray/dependencies"
require "ray/controller"
require "ray/file_model"

module Ray
  class Application
    def call(env)
      if env["PATH_INFO"] == "/favicon.ico"
        return [404, { "Content-Type" => "text/html" }, []]
      end

      klass, action = get_controller_and_action(env)
      controller = klass.new(env)
      controller.send(action)
      response = controller.get_response

      unless response
        controller.render(action.to_sym)
        response = controller.get_response
      end

      [
        response.status,
        response.headers,
        [response.body].flatten
      ]
    end
  end
end
