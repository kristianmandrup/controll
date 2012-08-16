require 'controll/flow_handler/base'

module Controll::FlowHandler
  class Render < Base
    class NoEventsDefinedError < StandardError; end
    class BadPathError < StandardError; end

    def initialize path #, events = []
      super path
      # @events = events
    end

    def perform controller
      raise BadPathError, "Bad path: #{path}" if path.blank?
      controller.render controller.send(path)
    end

    class << self
      def action event, path = nil
        raise Controll::FlowHandler::NoEventsDefinedError, "You must define a #{self}#events class method that returns a render map" unless respond_to?(:events)
        raise Controll::FlowHandler::NoEventsDefinedError, "The #{self}#events class method must return a render map, was #{events}" if events.blank?      
        event = normalize event
        self.new(path || default_path) if events.include? event.name
      end

      def default_path
        raise NotImplementedError, "You must set a default_path or override the #{self}#action class method"
      end

      # http://bugs.ruby-lang.org/issues/1082
      #   hello.singleton_class
      # Instead of always having to write:
      #   (class << hello; self; end)
      def set_default_path str = nil, &block
        (class << self; self; end).send :define_method, :default_path do 
          block_given? ? yield : str
        end
      end 

      def set_events *args, &block
        (class << self; self; end).send :define_method, :events do 
          block_given? ? yield : args.flatten
        end
      end 

      protected

      include Controll::FlowHandler::EventHelper      
    end
  end
end