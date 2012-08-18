module Controll
  module Event::Helper
    def normalize event
      case event
      when Symbol
        create_event event
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
