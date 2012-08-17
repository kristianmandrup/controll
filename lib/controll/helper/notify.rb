module Controll
  module Helper
    module Notify
      extend ActiveSupport::Concern

      included do
        attr_writer :notification_types

        notification_types.each do |type|
          define_method "create_#{type}" do |*args|
            create_notification args.first, type.to_sym, args.extract_options!
          end
        end
      end

      # msg stack
      def notifications
        @notifications ||= []
      end

      def main_event
        notifications.last || create_notice(:success)
      end

      def notify name, type = nil, options = {}        
        notifications << create_notification(name, type, options)
        self # enable method chaining on controller
      end

      protected

      include Controll::Event::Helper

      def error name = :error, options = {}
        notify name, :error, options
      end

      def success name = :success, options = {}
        notify name, :success, options
      end

      def create_notification name, type = nil, options = {}
        type ||= :notice
        raise ArgumentError, "Not a valid notification type: #{type}, must be one of: #{valid_notification_types}" unless valid_notification_type?(type)
        create_event name, type, options
      end
      alias_method :create_event, :create_notification

      def valid_notification_type? type
        notification_types.include? type.to_sym
      end

      def notification_types
        return self.class.notification_types if self.class.respond_to? :notification_types
        Controll::Notify::Flash.types
      end 

      # allows customization of notification types
      module ClassMethods
        def notification_types
          @notification_types ||= default_notification_types
        end

        def default_notification_types 
          Controll::Notify::Flash.types
        end
      end
      
      def process_notifications
        notifications.each do |message|
          message_handler.send(message.type).notify message.name, message.options
        end
      end
    end
  end
end