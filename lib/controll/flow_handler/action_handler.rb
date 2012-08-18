module Controll::FlowHandler
  class ActionHandler < Base
    def perform
      raise BadPathError, "Bad path: #{path}" if path.blank?
      raise Controll::FlowHandler::ControllNotEnabled, "Controller is not enabled with Controll. Missing #{controller_action} method" unless controller.respond_to? controller_action
      controller.send controller_action, resolved_path
    end

    def controller_action
      :do_render
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