module Controll
  module Notify
    class Translator
      attr_reader :caller, :key, :options

      def initialize caller, message
        @caller   = caller
        @key      = message.text
        @options  = options.symbolize_keys unless options.blank?
      end

      def translate
        options ? I18n.t(i18n_key) : I18n.t(i18n_key, options)
      end

      protected

      def i18n_key
        [namespace_key, key].join('.')
      end

      def namespace_key
        [middle, type].join('.').sub /^./, ''
      end

      def parts
        @parts ||= caller.class.name.split('::')
      end

      def middle
        parts[1..-2].join('.').underscore
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