module Controll
  module Event::Helper
    def normalize event, *args
      case event
      when Controll::Event
        event
      when Symbol
        create_event event, *args
      when Hash, Hashie::Mash
        create_event event.delete(:name), event
      else
        raise Controll::Event::InvalidError, "Event: #{event} could not be normalized, must be a Hash or Symbol"
      end
    end

    def create_event name, *args
      Controll::Event.new name, *args
    end
  end
end
