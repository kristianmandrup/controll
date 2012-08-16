module Controll::Notify
  class Message
    attr_reader :text, :options

    def initialize text, options = {}
      raise ArgumentError, "Message text must be a String or Symbol" unless text.kind_of?(String)
      @text, @options = [text.to_s.strip!, options]
    end

    protected

    def valid_text? text
      text.kind_of?(String) || text.kind_of?(Symbol)
    end
  end
end