module Controll::FlowHandler
  class Mapper
    attr_reader :event_map, :event

    NoRedirectionFoundError = Controll::FlowHandler::NoRedirectionFoundError

    def initialize event, event_map
      @event ||= normalize event

      unless valid_map? event_map
        raise ArgumentError, "Invalid redirect map: #{event_map}, must be a non-empty Hash" 
      end
      @event_map ||= event_map
    end

    # An event can also be a Symbol,
    # in which case it is a :notice event
    def map_event
      event_map.each do |path, events|            
        return path.to_s if valid? events
      end
      raise NoRedirectionFoundError, "No path could be found for event: #{event.inspect} in map: #{event_map}" 
    end

    protected

    include Controll::Event::Helper

    def valid_map? event_map
      event_map.kind_of?(Hash) && !event_map.blank?
    end

    def valid? events
      matcher(event).match?(events)
    end

    def matcher event
      @matcher ||= Controll::Event::Matcher.new event
    end        
  end
end
