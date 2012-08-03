module Controll
  class Assistant
    attr_reader :controller, :options

    def initialize controller, options = {}
      @controller = controller
      @options = options
    end
  end
end

module Controll
  class DelegateAssistant < Assistant
    def method_missing(meth, *args, &block)
      controller.send(meth, *args, &block)
    end        
  end
end
