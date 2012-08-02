module FlowHandler
  class Redirect < Base
    def initialize path, redirect_map = nil
      super path
      @redirect_map = redirect_map if redirect_map
    end

    def perform controller
      controller.do_redirect controller.send(path)
    end

    def self.action event
      redirect_map.each do |path, events|
        return self.new(path) if events.include? event
      end
      nil
    end

    def self.redirect_map
      {}
    end
  end
 end