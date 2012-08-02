require 'controll/message_handler/flash'

module MessageHandler
  class Notify < Flash
    def notify name, options = {}      
      opts = self.options.merge(options)
      signal notify_msg(name, opts)
    end

    protected

    def notify_msg name, opts = {}
      msg = send(name) if respond_to? name
      msg ||= msg_map[name.to_sym] if respond_to? :msg_map
      msg ||= name if i18n_map_match? name

      msg_error! if !msg
      
      msg.strip
      # try various approaches!
      case msg
      when Symbol
        t "#{i18n_key}.#{msg}", opts
      when String
        return replace_args(msg, opts) if msg =~ /{{.*}}/
        msg
      else
        msg_error!
      end
    end

    def msg_error!
      raise "Notify message could not be generated for: #{name}"
    end

    def i18n_map_match? name
      respond_to?(:i18n_map) && i18n_map.include?(name.to_sym)
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
