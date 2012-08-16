module Controll::FlowHandler
  class Redirect < Base
    class Mapper
      attr_reader :redirect_map, :event

      def initialize event, redirect_map
        @event ||= normalize event

        unless valid_map? redirect_map
          raise ArgumentError, "Invalid redirect map: #{redirect_map}, must be a Hash" 
        end
        @redirect_map ||= redirect_map
      end

      # An events can also be a Symbol,
      # in which case it is a :notice event
      def map
        redirect_map.each do |path, events|            
          return path.to_s if valid? events
        end
        raise Controll::FlowHandler::NoRedirectionFoundError, "No path could be found for event: #{event} in map: #{redirect_map}" 
      end

      protected

      include Controll::FlowHandler::EventHelper

      def valid_map? redirect_map
        redirect_map.kind_of?(Hash) && !redirect_map.blank?
      end

      def valid? events
        matcher(event).match?(events)
      end

      def matcher event
        @matcher ||= Controll::Helper::EventMatcher.new event
      end        
    end
  end
end