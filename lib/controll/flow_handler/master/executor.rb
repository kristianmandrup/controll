module Controll::FlowHandler
  class Control    
    class Executor < Controll::Executor::Base
      NoEventsDefinedError    = Controll::FlowHandler::NoEventsDefinedError
      NoRedirectionFoundError = Controll::FlowHandler::NoRedirectionFoundError    

      def initialize initiator, options = {}
        super
        # puts "options: #{options}"
      end

      def execute        
        action_handlers.each do |action_handler|
          begin          
            action_handler_clazz = handler_class(action_handler)
            next unless action_handler_clazz
            return action_handler_clazz.action(event)
          rescue NoEventsDefinedError => e
            errors << e
          rescue NoRedirectionFoundError => e
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
        Fallback.new controller, event
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