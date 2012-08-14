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
        attr_reader :signal_type

        def type name
          @signal_type = name
        end
      end

      protected

      def notify_msg name, opts = {}
        opts = options.merge(opts).stringify_keys

        msg = send(name) if respond_to? name
        msg ||= messages[name.to_sym] if respond_to? :messages
        msg ||= name.to_sym

        # if name is not mapped to a message, it could well be, that the 
        # event should not generate a nofification message
        return nil if !msg
                
        # try various approaches!
        case msg
        when Symbol
          translate msg, opts
        when String
          msg.strip!
          return replace_args(msg, opts) if msg =~ /{{.*}}/
          msg
        else
          msg_error!
        end
      rescue
      end

      def msg_error!
        raise NotifyMappingError, "Notify message could not be generated for: #{name}"
      end

      def translate msg, opts = {}
        I18n.t i18n_key(msg), opts.symbolize_keys
      end

      def replace_args msg, opts
         # Parses and compiles the template
        Liquid::Template.parse(msg).render(opts)
      end

      def i18n_key msg
        parts = self.class.name.split('::')
        middle = parts[1..-2].join('.').underscore
        type = parts.last.sub(/Msg$/, '').underscore
        ns = [middle, type].join('.').sub /^./, ''
        [ns,msg].join('.')
      end        
    end
  end
end