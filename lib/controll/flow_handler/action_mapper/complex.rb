module Controll::FlowHandler::ActionMapper
  class Complex < PathAction
    attr_reader :maps

    class << self
      attr_writer :action_clazz
      attr_reader :types

      # this method could be generated whenever a class inherits from ActionHandler class?
      def inherited base
        if base.parent.respond_to? :add_action_handler
          base.add_action_handler self.name.demodulize
        end
      end

      def action controller, event, maps, action_types = nil
        action_types ||= types
        path = path_finder(event, maps, action_types).map
        self.new controller, path unless path.blank?
      end

      # reader
      def map_for type = :notice
        @maps ||= {}
        @maps[type.to_sym] || {}
      end

      # writer
      # also auto-adds type to types
      def maps *args, &block
        @maps ||= {}
        return @maps if args.empty? && !block_given?

        type = args.first.kind_of?(Symbol) ? args.shift : :notice        
        @maps[type.to_sym] = block_given? ? yield : args.first
        @types << type unless types.include?(type)
      end 

      protected

      def path_finder event, maps, types
        path_finder_class.new event, maps, types
      end

      def path_finder_class
        Controll::FlowHandler::EventMapper::PathFinder
      end
    end
  end
 end
