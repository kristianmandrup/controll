module Controll::FlowHandler
  class Redirect < Base
    class Action
      attr_reader :event

      # event is a Hashie::Mash or simply a Symbol (default notice event)
      def initialize event
        @event = normalize_event(event)
      end

      def create
        matching_maps.each do |redirect_map|
          next unless map_for(redirect_map)
          redirect = handle_map redirect_map, matcher
          return redirect unless redirect.blank?
        end
        raise Controll::FlowHandler::Redirect::NoRedirectionFoundError, "No redirection could be found for: #{event} in any of #{matching_maps}"
      end

      protected

      # TODO: remove duplicate method!
      def normalize_event event
        case event
        when Symbol
          Hashie::Mash.new name: event, type: :notice
        when Hash, Hashie::Mash
          event
        else
          raise Controll::InvalidEvent, "Event: #{event} could not be normalized, must be a Hash or Symbol"
        end
      end

      def map_for name
        parent_class.send(name) if parent_class.respond_to?(name)
      end

      def parent_class
        self.class.parent
      end

      def redirect_maps
        parent_class.redirect_maps
      end

      def matching_maps
        @matching_maps ||= redirect_maps.select {|map| event_map_match?(event, map) }
      end

      # An events can also be a Symbol,
      # in which case it is a :notice event
      def handle_map redirect_map, matcher
        map_for(redirect_map).each do |path, events|
          valid = matcher.match?(events)
          # puts "matcher: #{matcher.inspect} - #{events} - #{valid}"
          return self.new(path) if valid
        end
        nil
      end        

      def event_matcher event
        @event_matcher ||= Controll::Helper::EventMatcher.new event
      end

      # Special - :redirections applies for :notice events
      # :error_redirections applies for :error events and so on
      def event_map_match? event, map
        (event.type == :notice && map == :redirections) || map.to_s =~/^#{event.type}/
      end
    end
  end
end