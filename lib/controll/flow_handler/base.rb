module Controll::FlowHandler
  class Base
    attr_reader :path

    def initialize path
      @path = path.to_s
    end

    def perform controller
      raise NotImplementedError, 'You must implement the #perform method'
    end

    class << self
      def action event
        raise NotImplementedError, 'You must implement the #action class method'
      end

      def event_name_of event
        event.respond_to?(:name) ? event.name.to_sym : event
      end    

      def event_type_of event
        event.respond_to?(:type) ? event.type.to_sym : :notice
      end
    end
  end
end