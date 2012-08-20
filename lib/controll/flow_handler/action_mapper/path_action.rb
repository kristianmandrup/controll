module Controll::FlowHandler::ActionMapper
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
      # do sth useful here?
      def inherited base
      end
    end
  end
end