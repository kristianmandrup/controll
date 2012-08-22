module Controll::Flow
  class Master    
    class Executor < Controll::Executor::Base
      Flow = Controll::Flow

      NoEventsDefinedError  = Flow::NoEventsDefinedError
      NoMappingFoundError   = Flow::NoMappingFoundError

      attr_reader :event, :action_handlers
        
      def initialize initiator, options
        raise ArgumentError, "Must take an options arg" unless options.kind_of?(Hash)
        raise ArgumentError, "Must take an :event option" unless options[:event]
        raise ArgumentError, "Must take an :action_handlers option" unless options[:action_handlers]
        super
        @event = options[:event]
        @action_handlers = options[:action_handlers]
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

      def fallback
        fallback_class.new controller, event
      end

      def fallback_class
        Flow::Action::Fallback
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