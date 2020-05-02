require "erubis"

module Ray
  class View
    def set_vars(instance_vars)
      instance_vars.each do |name, value|
        instance_variable_set(name, value)
      end
    end

    def evaluate(template)
      eruby = Erubis::Eruby.new(template)
      eval eruby.src # or eruby.evaluate(self)
    end

    # Example view helper method
    def h(str)
      URI.escape(str)
    end
  end
end
