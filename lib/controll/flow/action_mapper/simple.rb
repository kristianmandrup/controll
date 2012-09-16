module Controll::Flow::ActionMapper
  class Simple < Base
    NoEventsDefinedError      = Controll::Flow::NoEventsDefinedError
    NoDefaultPathDefinedError = Controll::Flow::NoDefaultPathDefinedError

    # TODO: Should combine with Redirecter style, allowing for multiple render path mappings!
    # This is fx useful for Wizards etc. where one Controller can render to many views, depending on state
    class << self
      def inherited base
        if base.parent.respond_to? :add_action_handler
          base.add_action_handler self.name.demodulize
        end
      end

      def action controller, event, path = nil
        check!
        event = normalize event
        path_action_class.new(controller, path || default_path) if events.include? event.name
      end

      # http://bugs.ruby-lang.org/issues/1082
      #   hello.singleton_class
      # Instead of always having to write:
      #   (class << hello; self; end)
      def default_path str = nil, &block
        (class << self; self; end).send :define_method, :default_path do 
          block_given? ? instance_eval(&block) : str
        end
      end 

      def events *args, &block
        (class << self; self; end).send :define_method, :events do 
          args.flatten
        end

        default_path(&block) if block_given?
      end 

      protected

      def check!
        unless respond_to?(:events) && !events.blank?
          raise NoEventsDefinedError, "You must define the events/actions that can be mapped by this class" 
        end

        unless respond_to?(:default_path) && !default_path.blank?
          raise NoDefaultPathDefinedError, "You must set a default_path to be routed to if no event/action matches"
        end
      end        

      include Controll::Event::Helper      
    end
  end
end
