module Controll::Flow::ActionMapper
  class Action
    attr_reader :path, :controller, :errors

    def initialize controller, path
      @controller = controller
      @path = path.to_s
    end

    class << self
      def action controller, event
        raise NotImplementedError, 'You must implement the #action class method'
      end
    end

    def set_errors *errors
      @errors = errors.flatten
    end

    def errors
      @errors |= []
    end

    protected

    def controller_action
      @controller_action ||= "do_#{type}"
    end          

    def error_check!
      unless controller.respond_to? controller_action
        raise Controll::NotEnabled, "Controll::Enabler has not been included in #{controller.class}. Missing #{controller_action} method"
      end
    end
  end
end