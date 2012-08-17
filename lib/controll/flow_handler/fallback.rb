module Controll::FlowHandler
  class Fallback < Base
    attr_reader :event

    def initialize event
      @event = event
    end

    def perform controller
      controller.fallback
    end

    class << self
      def action event
        self.new event
      end
    end    
  end
end