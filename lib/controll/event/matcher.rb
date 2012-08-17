module Controll
  class Event::Matcher
    attr_reader :event

    def initialize event
      @event = normalize event
    end

    def match? events
      normalized(events).include? event.name
    end

    protected

    include Controll::Event::Helper

    def normalized events
      [events].flatten.map(&:to_sym)
    end
  end
end