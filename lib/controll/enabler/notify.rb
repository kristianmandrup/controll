module Controll
  module Enabler
    module Notify
      extend ActiveSupport::Concern

      included do
        Controll::Event.valid_types.each do |type|
          meth = "create_#{type}"
          define_method meth do |*args|
            return create_event type, type if args.empty?
            create_event args.first, type, args[1..-1]
          end
          alias_method type, meth 
        end
      end

      include Controll::Event::Helper

      def notify event, *args
        events << normalize(event, *args)
        self # enable method chaining on controller
      end

      # event stack
      def events
        @events ||= Controll::Events.new
      end

      def main_event
        events.last || create_success
      end

      protected      
      
      def process_events notifier = nil
        notifier ||= self.notifier
        events.each do |event|
          notifier.send(event.type).notify event.name, event.options
        end
      end
    end
  end
end