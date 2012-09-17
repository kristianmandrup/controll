module Controll::Flow
  module EventMapper
    class PathFinder
      attr_accessor :event, :maps, :types

      NoMappingFoundError = Controll::Flow::NoMappingFoundError

      # event <Event>
      def initialize event, maps, types = []
        raise ArgumentError, "Event argument must not be empty" if event.blank?
        raise ArgumentError, "Maps argument must not be empty" if maps.blank?
        @event = normalize event
        @types = types unless types.blank?
        @maps = maps
      end

      def path
        @path ||= mapper.map_event 
      rescue StandardError => e
        raise NoMappingFoundError, "No event mapping could be found for: #{event.inspect} in: #{maps}. Cause: #{e}"
      end

      protected

      include Controll::Event::Helper

      def event_map
        @event_map ||= maps[event.type] || {}
      end

      def mapper
        @mapper ||= Controll::Flow::EventMapper::Util.new event, event_map
      end      
    end
  end
end