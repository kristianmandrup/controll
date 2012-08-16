module Controll::FlowHandler
  module EventHelper
    def types
      @types ||= [:notice, :error]
    end

    def normalize event
      case event
      when Symbol
        Hashie::Mash.new name: event, type: :notice
      when Hash, Hashie::Mash
        event
      else
        raise Controll::InvalidEvent, "Event: #{event} could not be normalized, must be a Hash or Symbol"
      end
    end
  end
end