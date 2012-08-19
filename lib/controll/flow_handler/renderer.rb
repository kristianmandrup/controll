module Controll::FlowHandler
  class Renderer < PathAction
    NoEventsDefinedError      = Controll::FlowHandler::NoEventsDefinedError
    NoDefaultPathDefinedError = Controll::FlowHandler::NoDefaultPathDefinedError

    def type
      :render
    end

    class << self
      def inherited base
        if base.parent.respond_to? :add_action_handler
          base.add_action_handler self.name.demodulize
        end
      end

      def action controller, event, path = nil
        check!
        event = normalize event
        self.new(controller, path || default_path) if events.include? event.name
      end

      # http://bugs.ruby-lang.org/issues/1082
      #   hello.singleton_class
      # Instead of always having to write:
      #   (class << hello; self; end)
      def default_path str = nil, &block
        (class << self; self; end).send :define_method, :default_path do 
          block_given? ? yield : str
        end
      end 

      def events *args, &block
        (class << self; self; end).send :define_method, :events do 
          block_given? ? yield : args.flatten
        end
      end 

      protected

      def check!
        unless respond_to?(:events) && !events.blank?
          raise NoEventsDefinedError, "You must define the events that can be rendered by this class" 
        end

        unless respond_to?(:default_path) && !default_path.blank?
          raise NoDefaultPathDefinedError, "You must set a default_path to be rendered if no event matches"
        end
      end        

      include Controll::Event::Helper      
    end
  end
end