require "ray/file_model"

module Ray
  class Controller
    include Ray::Model

    def initialize(env)
      @env = env
      @routing_params = {}
    end

    def self.action(action, routing_params = {})
      proc { |env| self.new(env).dispatch(action, routing_params) }
    end

    def dispatch(action, routing_params = {})
      @routing_params = routing_params
      self.send(action)
      response = get_response
      unless response
        render(action.to_sym)
        response = get_response
      end

      [
        response.status,
        response.headers,
        [response.body].flatten
      ]
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
      request.params.merge(@routing_params)
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
      view = View.new
      view.set_vars(view_variables)
      view.evaluate(template)
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
