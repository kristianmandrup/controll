module Controll
  module Helper
    module Notify
      # msg stack
      def notifications
        @notifications ||= []
      end

      def main_event
        notifications.last || create_notice(:success)
      end

      def notify name, *args
        options = args.extract_options!
        type = args.first || :notify
        notifications << Hashie::Mash.new(name: name, type: type, options: options)
        self # enable method chaining on controller
      end

      def create_notification name, type, options = {}
        Hashie::Mash.new(name: name, type: type, options: options)
      end

      # allows customization of notification types
      class << self
        attr_writer :notification_types

        def notification_types
          @notification_types ||= default_notification_types
        end

        def default_notification_types 
          [:notice, :error]
        end
      end

      notification_types.each do |type|
        define_method "create_#{type}" do |*args|
          create_notification args.first, type.to_sym, args.extract_options!
        end
      end

      def error name = :error, options = {}
        notify name, :error, options
      end
      
      def process_notifications
        notifications.each do |message|
          message_handler.send(message.type).notify message.name, message.options
        end
      end
    end
  end
end