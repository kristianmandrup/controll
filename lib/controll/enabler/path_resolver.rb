module Controll::Enabler
  class PathResolver
    attr_reader :caller, :event_map

    ActionMapper = Controll::Flow::ActionMapper

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
      when Action::Fallback
        nil
      when Action::PathAction
        action.resolved_path
      when Symbol, Controll::Event
        resolve_event action
      else
        resolve_event
      end      
    rescue Controll::Flow::PathActionError
      nil            
    end

    def resolve_event event = nil
      notify event if event
      mapper.map_event
    end

    def mapper
      @mapper ||= Controll::Flow::EventMapper::Util.new main_event, event_map
    end      
  end
end
