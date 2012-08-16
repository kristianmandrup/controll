require 'liquid'
require 'controll/notify/flash'

module Controll
  module Notify
    class Base < Flash
      class NotifyMappingError < StandardError; end

      def notify name, options = {}      
        @options.merge! options if options.kind_of? Hash
        signal notify_msg(name)
      end

      def self.inherited(base)
        base.extend ClassMethods
      end

      module ClassMethods
        def signal_type
          self.name.demodulize.sub(/Handler$/, '').underscore.to_sym
        end
      end

      protected

      def notify_msg name, opts = {}
        opts = options.merge(opts).stringify_keys

        msg = send(name) if respond_to? name
        msg ||= messages[name.to_sym] if respond_to? :messages
        msg ||= name.to_sym

        message = create_message msg, opts
                
        # try various approaches!
        case msg
        when Symbol
          translate message
        when String
          return replace_args(message) if msg =~ /{{.*}}/
          msg
        else
          msg_error!
        end
      rescue
      end

      def msg_error!
        raise NotifyMappingError, "Notify message could not be generated for: #{name}"
      end

      def replace_args message
         # Parses and compiles the template
        Liquid::Template.parse(message.text).render(message.options)
      end

      def translate message     
        translator(message).translate
      end

      def translator message
        Controll::Notify::Translator.new self, message
      end
    end
  end
end