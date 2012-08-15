module Controll
  module Helper
    class PathResolver
      class PathResolverError < StandardError; end

      attr_reader :caller

      def initialize caller
        @caller = caller
      end

      def extract_path type, *args
        if args.first.kind_of?(Symbol)
          raise "Caller must have a notice method" unless caller.respond_to? :notice
          caller.notice args.first
          resolve_path type
        else      
          args.empty? ? resolve_path(type) : args.first
        end
      end

      def resolve_path type
        raise "Caller must have a #main_event method" unless caller.respond_to? :main_event
        caller.send(type).each do |path, events|
          return path.to_s if matches? events
        end
        raise PathResolverError, "Path could not be resolved for: #{event_name}"
      end

      protected

      def matches? events
        event_matcher.match?(events)
      end

      def event_matcher
        @event_matcher ||= EventMatcher.new event
      end

      def event
        @event ||= caller.main_event
      end
    end
  end
end