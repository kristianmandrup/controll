module Controll::Helper
  class EventMatcher
    attr_reader :event

    def initialize event
      @event = normalize event
    end

    def match? events
      normalized(events).include? event.name
    end

    protected

    include Controll::FlowHandler::EventHelper

    def normalized events
      [events].flatten.map(&:to_sym)
    end
  end
end