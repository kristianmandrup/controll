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

      # the action resulting from executing the flow. 
      # Should be an instance of either:
      # - Fallback
      # - Redirecter
      # - Renderer
      def action
        @action ||= flow.execute
      end    

      # @flowhandler ||= Controll::Flow::Master.new self
      def flow
        raise NotImplementedError, '#flow must return the Controll::Flow::Master instance to be used'
      end
    end
  end
end