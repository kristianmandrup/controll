module Controll::Enabler
  class PathHandler
    attr_reader :controller, :type, :options, :path

    def initialize controller, type
      @controller, @type = [controller, type]
    end

    def self.renderer controller, map
      self.new controller, map, :render
    end

    def self.redirecter controller, map
      self.new controller, map, :redirect
    end

    def execute *args
      extract! *args
      process_notifications
      path ? handle_path : fallback
    end

    protected

    def map
      @map ||= controller.class.send("#{type}_map") 
    end

    alias_method :control_action, :type

    def handle_path
      controller.send control_action, path, options
    end

    def fallback
      controller.do_fallback action
    end

    def extract! *args
      @options = args.extract_options!
      action = args.first
      @path = path_resolver(map).resolve action
    end

    def path_resolver map
      @path_resolver ||= PathResolver.new controller, map
    end    
  end
end