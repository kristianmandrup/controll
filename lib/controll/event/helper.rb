module Controll
  module Event::Helper
    def normalize event, *args
      case event
      when Controll::Event
        event
      when Symbol, String
        create_event event.to_sym, *args
      when Hash, Hashie::Mash
        create_event event.delete(:name), event
      else
        raise Controll::Event::InvalidError, "Event: #{event} could not be normalized, must be a Hash, String or Symbol"
      end
    end

    def create_event name, *args
      Controll::Event.new name, *args
    end
  end
end
