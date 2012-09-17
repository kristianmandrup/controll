module Controll::Flow::ActionMapper
  class Complex < Base
    attr_reader :event_maps

    class << self
      attr_writer :action_clazz
      attr_reader :types, :event_maps

      # this method could be generated whenever a class inherits from ActionHandler class?
      def inherited base
        if base.parent.respond_to? :add_action_handler
          base.add_action_handler self.name.demodulize
        end
      end

      def action controller, event
        action_types ||= types
        path = path_finder(event).path
        path_action_class.new controller, path unless path.blank?
      end

      # reader
      def event_map_for type = :notice
        @event_maps ||= {}
        event_maps[type.to_sym] || {}
      end

      # writer
      # also auto-adds type to types
      def event_map *args, &block
        @event_maps ||= {}
        @types ||= []
        return @event_maps if args.empty? && !block_given?

        type = args.first.kind_of?(Symbol) ? args.shift : :notice        
        event_maps[type.to_sym] = block_given? ? instance_eval(&block) : args.first
        @types << type unless types.include?(type)
      end 

      protected

      def path_finder event
        raise Controll::Flow::NoMappingFoundError, "No event maps defined" if event_maps.blank?
        path_finder_class.new event, event_maps, types
      end

      def path_finder_class
        Controll::Flow::EventMapper::PathFinder
      end
    end
  end
 end
