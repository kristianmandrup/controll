require 'controll/flow_handler/base'

module FlowHandler
  class Render < Base
    def initialize path, events = []
      super path
      @events = events
    end

    def perform controller
      controller.render controller.send(path)
    end

    def self.action event
      self.new(default_path) if events.include? event
    end

    def self.default_path
      raise NotImplementedError, 'You must set a default_path or override the #action class method'
    end 
  end
end