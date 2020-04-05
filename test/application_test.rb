require_relative "test_helper"

class TestController < Ray::Controller
  def index
    "Hello from Ray!"  # Not rendering a view
  end
end

class TestApp < Ray::Application
  def get_controller_and_action(env)
    [TestController, "index"]
  end
end

class RayAppTest < Minitest::Test
  include Rack::Test::Methods

  def app
    app = TestApp.new
    builder = Rack::Builder.new
    builder.run app
  end

  def test_request
    get "/"

    assert last_response.ok?
    assert_equal last_response.body, "Hello from Ray!"
  end
end
