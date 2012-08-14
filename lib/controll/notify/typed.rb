require 'controll/notify/flash'

module Controll
  module Notify
    class Typed < Flash
      class MissingNotifyClass < StandardError; end

      def notice        
        raise MissingNotifyClass, "#{msg_class(:notice)} class missing" unless msg_class(:notice)
        @notice ||= msg_class(:notice).new flash #, options
      end

      def error
        raise MissingNotifyClass, "#{msg_class(:warning)} class missing" unless msg_class(:error)
        @error ||= msg_class(:error).new flash #, options
      end

      def success
        raise MissingNotifyClass, "#{msg_class(:success)} class missing" unless msg_class(:success)
        @success ||= msg_class(:success).new flash #, options
      end

      def warning
        raise MissingNotifyClass, "#{msg_class(:warning)} class missing" unless msg_class(:warning)
        @warning ||= msg_class(:warning).new flash #, options
      end

      protected

      def msg_class name
        msg_classes[name] ||= "#{self.class}::#{name.to_s.camelize}Msg".constantize
      end 

      def msg_classes
        @msg_classes ||= {}
      end
    end
  end
end