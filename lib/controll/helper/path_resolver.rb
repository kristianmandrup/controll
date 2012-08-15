module Controll
  module Helper
    class PathResolver
      attr_reader :caller

      def initialize caller
        @caller = caller
      end

      def extract_path type, *args
        if args.first.kind_of?(Symbol)
          parent.notice args.first
          resolve_path type
        else      
          args.empty? ? resolve_path(type) : args.first
        end
      end

      def resolve_path type
        caller.send(type).each do |path, events|
          return path if events.include? caller.main_event
        end
      end
    end
  end
end