module Ray
  class Router
    def initialize
      @rules = []
    end

    def match(url, *args)
      options = {}
      options = args.pop if args[-1].is_a?(Hash)
      options[:default] ||= {}

      destination = nil
      destination = args.pop if args.size > 0

      raise "Too many args!" if args.size > 0

      parts = url.split("/")
      parts.select! { |part| !part.empty? }

      dynamic_segments = []
      regexp_parts = parts.map do |part|
        if part[0] == ":"
          dynamic_segments << part[1..-1]
          "([a-zA-Z0-9]+)"
        elsif part[0] == "*"
          dynamic_segments << part[1..-1]
          "(.*)"
        else
          part
        end
      end

      regexp = regexp_parts.join("/")

      @rules.push(
        :regexp => Regexp.new("^/#{regexp}$"),
        :dynamic_segments => dynamic_segments,
        :destination => destination,
        :options => options
      )
    end

    def check_url(url)
      @rules.each do |rule|
        match_data = rule[:regexp].match(url)

        if match_data
          options = rule[:options]
          params = options[:default].dup
          rule[:dynamic_segments].each_with_index do |dynamic_segment, index|
            params[dynamic_segment] = match_data.captures[index]
          end

          if rule[:destination]
            return get_destination(rule[:destination], params)
          else
            controller = params["controller"]
            action = params["action"]
            return get_destination("#{controller}##{action}", params)
          end
        end
      end

      nil
    end

    def get_destination(destination, routing_params = {})
      return destination if destination.respond_to?(:call)

      if destination =~ /^([^#]+)#([^#]+)$/
        name = $1.capitalize
        controller_class = Object.const_get("#{name}Controller")
        return controller_class.action($2, routing_params)
      end

      raise "No destination: #{destination.inspect}"
    end
  end

  class Application
    def route(&block)
      @router ||= Router.new
      @router.instance_eval(&block)
    end

    def get_rack_app(env)
      raise "No routes!" unless @router
      @router.check_url(env["PATH_INFO"])
    end
  end
end
