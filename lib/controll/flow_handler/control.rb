module Controll::FlowHandler
  class Control
    attr_reader :controller, :action_handlers

    def initialize controller, action_handlers = []
      @controller = controller
      @action_handlers = action_handlers unless action_handlers.blank?
    end

    def execute
      use_action_handlers
      use_alternatives
      use_fallback if !executed? 
    end

    def action_handlers
      @action_handlers ||= [Redirect, Render]
    end

    protected

    delegate :command!, to: :controller

    # can be used to set up control logic that fall outside what can be done
    # with the basic action_handlers but can not be considered fall-back.
    def use_alternatives
    end

    def use_fallback
      raise NotImplementedError, 'You must define a #use_fallback method'
    end    

    def event
      raise NotImplementedError, 'You must define an #event method that at least returns an event (Symbol). You can use an Executor for this.'
    end

    def fallback_action
      do_redirect root_url
    end

    def use_action_handlers
      action_handlers.each do |action_handler|
        execute_with action_handler.action(event)
      end      
    end

    def execute_with action
      return if !action
      action.perform(controller)
      executed!
    end

    def executed!
      @executed = true
    end

    def executed? 
      @executed
    end
  end
end