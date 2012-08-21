module Controll::FlowHandler
  class Master    
    autoload :Macros,   'controll/flow_handler/master/macros'
    autoload :Executor, 'controll/flow_handler/master/executor'

    include Macros

    attr_reader :controller, :action, :options

    def initialize controller, options = {}
      @controller = controller
      @options    = options
    end

    # Uses Executor to execute each registered ActionHandler, such ad Renderer and Redirecter 
    # The first ActionHandler matching the event returns an appropriate Action
    # In case no ActionHandler matches, the Fallback action is returned
    def execute
      @action = executor.execute || fallback
      @action.set_errors errors
      @action
    end

    def executor
      @executor ||= Executor.new controller, executor_options
    end

    def executor_options
      {event: event, action_handlers: action_handlers}
    end

    delegate :errors, to: :executor

    class << self
      def action_handlers
        @action_handlers ||= []
      end

      def add_action_handler name
        @action_handlers ||= []
        @action_handlers << name.to_s.underscore.to_sym
      end

      def valid_handler? handler_type
        raise ArgumentError, "Must be a String or Symbol, was: #{handler_type}" if handler_type.blank?
        valid_handlers.include? handler_type.to_sym
      end

      def valid_handlers
        [:renderer, :redirecter]
      end

      def mapper_types
        [:simple, :complex]
      end      
    end

    protected

    delegate :command!, to: :controller

    def action_handlers
      self.class.action_handlers
    end

    def event
      raise Controll::FlowHandler::EventNotImplementedError, 'You must define an #event method that returns an event (or Symbol). You can use an Executor for this.'
    end
  end
end