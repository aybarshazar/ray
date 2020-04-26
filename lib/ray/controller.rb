require "erubis"

module Ray
  class Controller
    def initialize(env)
      @env = env
    end

    def env
      @env
    end

    def render(view_name)
      filename = File.join("app", "views", controller_name, "#{view_name}.html.erb")
      template = File.read(filename)
      eruby = Erubis::Eruby.new(template)
      eruby.result(view_variables.merge(:env => env))
    end

    def controller_name
      klass = self.class
      klass = klass.to_s.gsub(/Controller$/, "")
      Ray.to_underscore(klass)
    end

    def view_variables
      vars = {}
      (instance_variables - [:@env]).each do |variable|
        vars[variable] = instance_variable_get(variable)
      end
      vars
    end
  end
end
