module Controll::FlowHandler
  class PathAction < Action
    def perform
      raise BadPathError, "Bad path: #{path}" if path.blank?
      error_check!
      controller.send controller_action, self
    end

    def resolved_path
      controller.send(path)
    end

    class << self
      def inherited base
        raise NotImplementedError, 'You must implement the #inherited class method'
      end
    end
  end
end