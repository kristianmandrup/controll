require 'controll/notify/flash'

module Controll
  module Notify
    class Base < Flash
      Message = Controll::Notify::Message

      attr_reader :name

      def notify name, options = {}      
        @options.merge! options
        @name = name
        signal message_resolver.resolve
      end

      def self.inherited(base)
        base.extend ClassMethods
      end

      module ClassMethods
        def signal_type
          @signal_type ||= self.name.demodulize.sub(/Handler$/, '').underscore.to_sym
        end

        def type name
          @signal_type = name
        end
      end

      protected

      def message_resolver
        @message_resolver ||= Message::Resolver.new self, message
      end

      def message
        @message ||= Message.new text, options
      end      

      def text
        @text ||= resolve_text(name) || key
      end

      def key
        @key ||= name.to_sym
      end

      def resolve_text name
        return send(name) if respond_to? name
        messages[name.to_sym] if respond_to? :messages
      end
    end
  end
end