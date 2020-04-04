require_relative "test_helper"

class TestApp < Ray::Application
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
