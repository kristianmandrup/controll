module Controll::Flow::ActionMapper
  class Base
    class << self
      def path_action_class
        Controll::Flow::Action::PathAction
      end

      def action controller, event
        raise NotImplementedError, 'You must implement the #action class method'
      end
    end
  end
end
