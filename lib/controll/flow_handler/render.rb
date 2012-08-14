require 'controll/flow_handler/base'

module Controll::FlowHandler
  class Render < Base
    class NoEventsDefinedError < StandardError; end

    def initialize path #, events = []
      super path
      # @events = events
    end

    def perform controller
      controller.render controller.send(path)
    end

    def self.action event, path = nil
      raise NoEventsDefinedError, "You must define a #{self}#events class method that returns a render map" unless respond_to?(:events)
      raise NoEventsDefinedError, "The #{self}#events class method must return a render map, was #{events}" if events.blank?      

      event_name = event.respond_to?(:name) ? event.name : event

      self.new(path || default_path) if events.include? event_name
    end

    def self.default_path
      raise NotImplementedError, "You must set a default_path or override the #{self}#action class method"
    end 
  end
end