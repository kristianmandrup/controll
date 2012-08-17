module Controll::FlowHandler
  class Fallback
    def perform controller
      controller.fallback
    end
  end
end