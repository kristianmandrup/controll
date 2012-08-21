module Controll::Flow
  class Master    
    class Executor < Controll::Executor::Base
      Flow = Controll::Flow

      NoEventsDefinedError  = Flow::NoEventsDefinedError
      NoMappingFoundError   = Flow::NoMappingFoundError

      def initialize initiator, options = {}
        super
      end

      def execute        
        action_handlers.each do |action_handler|
          begin          
            action_handler_clazz = handler_class(action_handler)
            next unless action_handler_clazz
            return action_handler_clazz.action(controller, event)
          rescue NoEventsDefinedError => e
            errors << e
          rescue NoMappingFoundError => e
            errors << e
          end
        end
        fallback
      end

      def errors
        @errors ||= []
      end

      protected

      def event
        options[:event]
      end

      def fallback
        fallback_class.new controller, event
      end

      def fallback_class
        Flow::ActionMapper::Fallback
      end

      def action_handlers
        @action_handlers ||= options[:action_handlers]
      end

      def handler_class action_handler
        clazz = "#{initiator.class}::#{action_handler.to_s.camelize}"
        clazz.constantize
      rescue NameError
        nil
      end
    end
  end
end