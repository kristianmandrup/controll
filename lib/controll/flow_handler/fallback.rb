module Controll::FlowHandler
  class Fallback < Action
    attr_reader :controller, :event

    def initialize controller, event
      @controller = controller
      @event = event
    end

    def perform      
      error_check!
      controller.do_fallback self
    end
    
    def type
      :fallback
    end

    class << self
      def action controller, event
        self.new controller, event
      end
    end
  end
end