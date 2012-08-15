module Controll::Helper
  class EventMatcher
    attr_reader :event

    def initialize event
      @event = normalize_event(event)
    end

    def match? events
      normalized(events).include?(event.name)
    end

    protected

    def normalize_event event
      case event
      when Symbol
        Hashie::Mash.new name: event, type: :notice
      when Hash, Hashie::Mash
        event
      else
        raise Controll::InvalidEvent, "Event: #{event} could not be normalized, must be a Hash or Symbol"
      end
    end

    def normalized events
      [events].flatten.map(&:to_sym)
    end
  end
end