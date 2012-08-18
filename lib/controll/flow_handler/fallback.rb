module Controll::FlowHandler
  class Fallback < Base
    attr_reader :controller, :event

    def initialize controller, event
      @controller = controller
      @event = event
    end

    def perform
      raise Controll::NotEnabled, "Controller is not enabled with Controll. Missing #do_fallback method" unless controller.respond_to :do_fallback
      controller.do_fallback(event) if 
    end
  end
end