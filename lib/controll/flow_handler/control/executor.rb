module Controll::FlowHandler
  class Control    
    class Executor < Controll::Executor::Base
      NoEventsDefinedError    = Controll::FlowHandler::Render::NoEventsDefinedError
      NoRedirectionFoundError = Controll::FlowHandler::Redirect::NoRedirectionFoundError    

      def execute
        errors = []
        action_handlers.each do |action_handler|
          begin          
            action_handler_clazz = handler_class(action_handler)
            next unless action_handler_clazz
            action = action_handler_clazz.action(event)
            execute_with action
            return if executed?
          rescue NoEventsDefinedError => e
            errors << e
          rescue NoRedirectionFoundError => e
            errors << e
          end
        end
        raise ActionEventError, "#{errors.join ','}" unless errors.empty?
      end

      protected

      def action_handlers
        @action_handlers ||= options[:action_handlers]
      end

      def handler_class action_handler
        clazz = "#{initiator.class}::#{action_handler.to_s.camelize}"
        clazz.constantize
      rescue NameError
        nil
      end

      def execute_with action
        return if !action
        action.perform(controller)
        executed!  
      end

      def executed? 
        @executed
      end

      def executed!
        @executed = true
      end
    end
  end
end