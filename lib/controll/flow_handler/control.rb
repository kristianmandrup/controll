module Controll::FlowHandler
  class Control    
    autoload :Macros,   'controll/flow_handler/control/macros'
    autoload :Executor, 'controll/flow_handler/control/executor'

    ActionEventError = Controll::FlowHandler::ActionEventError

    include Macros

    attr_reader :controller, :action

    def initialize controller
      @controller = controller
    end

    # sets action to first action_handler that matches event
    # returns self
    def execute
      return executor.execute
    rescue StandardError
      fallback
    end

    def executor
      @executor ||= Executor.new self, action_handlers: action_handlers
    end

    delegate :executed?, to: :executor

    class << self
      def action_handlers
        @action_handlers ||= []
      end

      def add_action_handler name
        @action_handlers ||= []
        @action_handlers << name.to_s.underscore.to_sym
      end
    end

    protected

    attr_writer :action

    delegate :command!, to: :controller

    def action_handlers
      self.class.action_handlers
    end

    def event
      raise NotImplementedError, 'You must define an #event method that at least returns an event (Symbol). You can use an Executor for this.'
    end
  end
end