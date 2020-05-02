require "erubis"
require "ray/file_model"

module Ray
  class Controller
    include Ray::Model

    def initialize(env)
      @env = env
    end

    def request
      @request ||= Rack::Request.new(@env)
    end

    def response(text, status = 200, headers = {})
      raise "Already responded!" if @response

      body = [text].flatten
      @response = Rack::Response.new(body, status, headers)
    end

    def get_response # used internally in Ray
      @response
    end

    def params
      request.params
    end

    def render(view_name)
      text = render_view(view_name)
      status = 200
      headers = { "Content-Type" => "text/html" }
      response(text, status, headers)
    end

    private

    def render_view(view_name)
      filename = File.join("app", "views", controller_name, "#{view_name}.html.erb")
      template = File.read(filename)
      eruby = Erubis::Eruby.new(template)
      eruby.result(view_variables)
    end

    def controller_name
      klass = self.class
      klass = klass.to_s.gsub(/Controller$/, "")
      Ray.to_underscore(klass)
    end

    def view_variables
      vars = {}
      instance_variables.each do |variable|
        vars[variable] = instance_variable_get(variable)
      end
      vars
    end
  end
end
