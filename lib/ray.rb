require "ray/version"

module Ray
  class Application
    def call(env)
      [
        200,
        { "Content-Type" => "text/html" },
        ["Hello from Ray!"]
      ]
    end
  end
end
