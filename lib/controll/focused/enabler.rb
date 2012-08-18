module Controll
  module Focused
    module Enabler
      include Controll::Enabler

      def execute     
        action.perform
      end

      def self.assistant_methods *names
        delegate names, to: :assistant
      end

      protected

      # the action resulting from executing the flow_handler. 
      # Should be an instance of either:
      # - Fallback
      # - Redirecter
      # - Renderer
      def action
        @action ||= flow_handler.execute
      end    

      # @flowhandler ||= Controll::FlowHandler::Master.new self
      def flow_handler
        raise NotImplementedError, '#flow_handler must return the Controll::FlowHandler::Master instance to be used'
      end
    end
  end
end