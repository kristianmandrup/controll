module Controll::Notify
  class Message
    autoload :Translator,   'controll/notify/message/translator'
    autoload :Handler,      'controll/notify/message/handler'
    autoload :Resolver,     'controll/notify/message/resolver'

    attr_reader :text, :options

    def initialize text, options = {}
      raise ArgumentError, "Message text must be a String or Symbol" unless valid_text? text
      @text    = text
      @options = options
    end

    def translate?
      text.kind_of? Symbol
    end

    protected

    def valid_text? text
      text.kind_of?(String) || text.kind_of?(Symbol)
    end
  end
end