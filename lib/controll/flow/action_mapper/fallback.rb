module Controll::Flow::ActionMapper
  class Fallback < Action
    attr_reader :controller, :event

    def initialize controller, event = nil
      @controller = controller
      @event = event if event
    end

    def perform      
      error_check! if event
      controller.do_fallback self
    end
    
    def type
      :fallback
    end

    class << self
      def action controller, event = nil
        self.new controller, event
      end
    end
  end
end
