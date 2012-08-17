module Controll::Notify
  class Message
    class Resolver
      Message = Controll::Notify::Message

      attr_reader :caller, :message

      def initialize caller, message
        @caller = caller
        @message = message
      end

      def resolve
        message.translate? ? translator.translate : message_handler.handle
      end

      protected

      def message_handler
        Message::Handler.new message
      end

      def translator
        Message::Translator.new caller, message
      end
    end
  end
end