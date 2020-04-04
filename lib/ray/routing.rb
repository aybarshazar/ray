module Ray
  class Application
    def get_controller_and_action(env)
      _, controller, action, after = env["PATH_INFO"].split("/", 4)
      controller = controller.capitalize # quotes -> Quotes
      controller += "Controller" # Quotes -> QuotesController

      [Object.const_get(controller), action]
    end
  end
end
