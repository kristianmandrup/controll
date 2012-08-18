module Controll::FlowHandler
  class Master    
    autoload :Macros,   'controll/flow_handler/master/macros'
    autoload :Executor, 'controll/flow_handler/master/executor'

    include Macros

    attr_reader :controller, :action

    def initialize controller
      @controller = controller
    end

    # Uses Executor to execute each registered ActionHandler, such ad Renderer and Redirecter 
    # The first ActionHandler matching the event returns an appropriate Action
    # In case no ActionHandler matches, the Fallback action is returned
    def execute
      executor.execute || fallback
    # rescue StandardError
    #   fallback
    end

    def executor
      @executor ||= Executor.new controller, event: event, action_handlers: action_handlers
    end

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