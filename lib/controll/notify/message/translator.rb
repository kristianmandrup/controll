module Controll
  module Notify
    class Message
      class Translator
        attr_reader :caller, :key, :options

        def initialize caller, message
          @caller   = caller
          @key      = message.text
          @options  = message.options.symbolize_keys
        end

        def translate
          I18n.t i18n_key, options
        end

        protected

        def i18n_key
          [namespace_key, key].join('.')
        end

        def namespace_key
          [namespace, type].join('.').sub /^\\./, ''
        end

        def parts
          @parts ||= caller.class.name.split('::')
        end

        def namespace
          (parts.first == 'Notifiers' ? parts[1..-2] : parts[0..-2]).join('.').underscore          
        end
        
        def type
          parts.last.sub(/#{clazz_postfix}$/, '').underscore
        end

        def clazz_postfix
          'Handler'
        end
      end
    end
  end
end