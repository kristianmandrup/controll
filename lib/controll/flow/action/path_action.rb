module Controll::Flow::Action
  class PathAction < Base
    def perform
      raise BadPathError, "Bad path: #{path}" if path.blank?
      error_check!
      controller.send controller_action, self
    end

    def resolved_path
      controller.send(path)
    end

    protected

    # useful for path helpers used in event maps
    def method_missing(method_name, *args, &block)
      if controller.respond_to? method_name
        controller.send method_name, *args, &block
      else
        super
      end
    end
  end
end