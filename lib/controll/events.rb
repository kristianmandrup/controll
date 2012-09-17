module Controll
  class Events
    include Enumerable
    include Controll::Event::Helper

    attr_reader :events

    def initialize *events
      @events = events.flatten.map{|event| normalize event }
    end

    def each
      events.each {|event| yield event }
    end

    def << event
      events << event
    end

    def last
      events.last
    end

    def self.valid_types
      Controll::Event.valid_types
    end

    # fx error? - returns if any event of type error
    valid_types.each do |type|
      meth = :"#{type}?"
      define_method meth do
        self.any? {|event| event.send(meth) }
      end
    end

    # fx errors - returns all events of type error
    valid_types.each do |type|
      meth = type.to_s.pluralize
      define_method meth do
        self.select {|event| event.send(:"#{type}?") }
      end
    end

    def valid_types
      Controll::Event.valid_types
    end
  end
end