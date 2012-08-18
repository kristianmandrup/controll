module Controll::FlowHandler
  class Base
    attr_reader :path, :controller

    def initialize controller, path
      @controller = controller
      @path = path.to_s
    end

    class << self
      def action controller, event
        raise NotImplementedError, 'You must implement the #action class method'
      end
    end

    protected

    def controller_action
      @controller_action ||= "do_#{type}"
    end          

    def error_check!
      unless controller.respond_to? controller_action
        raise Controll::Enabler::NotIncluded, "Controll::Enabler has not been included in #{controller.class}. Missing #{controller_action} method"
      end
    end
  end
end