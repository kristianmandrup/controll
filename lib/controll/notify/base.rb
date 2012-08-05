require 'controll/notify/flash'

module Controll
  module Notify
    class Base < Flash
      def notify name, options = {}      
        opts = self.options.merge(options)
        signal notify_msg(name, opts)
      end

      protected

      def notify_msg name, opts = {}
        msg = send(name) if respond_to? name
        msg ||= messages[name.to_sym] if respond_to? :messages
        msg ||= name.to_sym

        # if name is not mapped to a message, it could well be, that the 
        # event should not generate a nofification message
        return !msg 
        
        msg.strip
        # try various approaches!
        case msg
        when Symbol
          translate msg, opts
        when String
          return replace_args(msg, opts) if msg =~ /{{.*}}/
          msg
        else
          msg_error!
        end
      rescue
      end

      def msg_error!
        raise "Notify message could not be generated for: #{name}"
      end

      def translate msg, opts = {}
        t "#{i18n_key}.#{msg}", opts
      rescue
      end

      def replace_args msg, opts
         # Parses and compiles the template
        Liquid::Template.parse(msg).render opts      
      end

      def i18n_key
        parts = self.class.name.split('::')
        middle = parts[1..-2].join('.').underscore
        type = parts.last.sub(/Msg$/, '').underscore
        [middle, type].join('.')
      end
        
      class << self
        attr_reader :signal_type

        def type name
          @signal_type = name
        end
      end
    end
  end
end