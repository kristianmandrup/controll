module Controll::Enabler
  class PathResolver
    attr_reader :caller, :event_map

    def initialize caller, event_map
      @caller     = caller
      @event_map = event_map
    end

    def resolve action = nil
      @path ||= handle action
    end

    protected

    alias_method :controller, :caller

    delegate :notify, :main_event, to: :caller

    def handle action
      case action
      when Controll::FlowHandler::Fallback
        nil
      when Controll::FlowHandler::PathAction
        action.resolved_path
      when Symbol, Controll::Event
        resolve_event action
      else
        resolve_event
      end      
    rescue Controll::FlowHandler::PathActionError
      nil            
    end

    def resolve_event event = nil
      notify event if event
      mapper.map_event
    end

    def mapper
      @mapper ||= Controll::FlowHandler::Mapper.new main_event, event_map
    end      
  end
end
