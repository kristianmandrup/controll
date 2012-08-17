require 'liquid'

module Controll::Notify
  class Message
    class Handler
      attr_reader :message

      def initialize message
        @message = message
      end

      def handle
        return args? ? replace_args : message.text
      rescue StandardError
        nil
      end

      protected

      delegate :text, to: :message

      def options
        @options ||= message.options.stringify_keys
      end

      def args?
        text =~ /{{.*}}/
      end

      def replace_args
         # Parses and compiles the template
        Liquid::Template.parse(text).render(options)
      end    
    end
  end
end