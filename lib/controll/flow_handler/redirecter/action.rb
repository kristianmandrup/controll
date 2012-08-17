module Controll::FlowHandler
  class Redirecter < Base
    class Action
      attr_accessor :event, :redirections, :types

      NoRedirectionFoundError = Controll::FlowHandler::NoRedirectionFoundError

      # event <Event>
      def initialize event, redirections, types = []
        raise ArgumentError, "Must take :event option, was: #{event}" if event.blank?
        raise ArgumentError, "Must take non-empty :redirections option, was: #{redirections}" if redirections.blank?
        @event = normalize event
        @types = types unless types.blank?
        @redirections = redirections
      end

      def map        
        if redirect.blank?
          raise NoRedirectionFoundError, "No redirection could be found for: #{event} in: #{redirections}"
        end
        redirect        
      end

      protected

      include Controll::FlowHandler::EventHelper

      def redirect
        @redirect ||= mapper(redirect_map).map 
      rescue StandardError => e
        raise NoRedirectionFoundError, "No redirection could be found for: #{event} in: #{redirections}. Cause: #{e}"
      end

      def redirect_map
        @redirect_map ||= redirections[event.type] || {}
      end

      def mapper redirect_map
        @mapper ||= mapper_class.new event, redirect_map
      end      

      def mapper_class
        Controll::FlowHandler::Redirect::Mapper
      end
    end
  end
end