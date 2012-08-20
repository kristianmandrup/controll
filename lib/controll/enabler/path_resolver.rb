module Controll::Enabler
  class PathResolver
    attr_reader :caller, :event_map

    ActionMapper = Controll::FlowHandler::ActionMapper

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
      when ActionMapper::Fallback
        nil
      when ActionMapper::PathAction
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
      @mapper ||= Controll::FlowHandler::EventMapper::Util.new main_event, event_map
    end      
  end
end
