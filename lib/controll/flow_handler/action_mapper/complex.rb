module Controll::FlowHandler::ActionMapper
  class Complex < PathAction
    attr_reader :maps

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
        path = path_finder(event).map
        self.new controller, path unless path.blank?
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
        return @event_maps if args.empty? && !block_given?

        type = args.first.kind_of?(Symbol) ? args.shift : :notice        
        event_maps[type.to_sym] = block_given? ? instance_eval(&block) : args.first
        @types << type unless types.include?(type)
      end 

      protected

      def path_finder event
        path_finder_class.new event, event_maps, types
      end

      def path_finder_class
        Controll::FlowHandler::EventMapper::PathFinder
      end
    end
  end
 end
