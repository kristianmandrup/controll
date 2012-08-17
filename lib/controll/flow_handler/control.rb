module Controll::FlowHandler
  class Control    
    autoload :Macros,   'controll/flow_handler/control/macros'
    autoload :Executor, 'controll/flow_handler/control/executor'

    ActionEventError = Controll::FlowHandler::ActionEventError

    include Macros

    attr_reader :controller, :action_handlers

    def initialize controller, action_handlers = []
      @controller = controller
      @action_handlers = action_handlers unless action_handlers.blank?
    end

    def execute
      executor.execute
      fallback if !executed?
      self
    end

    def executor
      @executor ||= Executor.new self, action_handlers: action_handlers
    end

    def action_handlers
      @action_handlers ||= []
    end

    class << self
      def add_action_handler name
        @action_handlers ||= []
        @action_handlers << name.to_s.underscore.to_sym
      end
    end

    protected

    delegate :command!, to: :controller

    def event
      raise NotImplementedError, 'You must define an #event method that at least returns an event (Symbol). You can use an Executor for this.'
    end

    def fallback_action
      do_redirect root_url
    end
  end
end