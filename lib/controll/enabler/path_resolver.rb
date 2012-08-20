module Controll
  module Enabler
    class PathResolver
      class PathResolverError < StandardError; end

      attr_reader :caller

      def initialize caller
        @caller = caller
      end

      def extract_path map_type, path = nil
        return resolve_path(map_type) if path.nil?

        case path
        when Symbol
          raise "Caller must have a notice method" unless caller.respond_to? :notice
          caller.notice path
        end
        resolve_path map_type
      end

      def resolve_path map_type
        raise "Caller must have a #main_event method" unless caller.respond_to? :main_event
        caller.send(map_type).each do |path, events|
          return path.to_s if matches? events
        end
        raise PathResolverError, "Path could not be resolved for: #{event.name}"
      end

      protected

      def matches? events
        event_matcher.match?(events)
      end

      def event_matcher
        @event_matcher ||= Controll::Event::Matcher.new event
      end

      def event
        @event ||= caller.main_event
      end
    end
  end
end