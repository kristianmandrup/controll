module Controll::FlowHandler
  class Control
    class ActionEventError < StandardError; end

    attr_reader :controller, :action_handlers

    def initialize controller, action_handlers = []
      @controller = controller
      @action_handlers = action_handlers unless action_handlers.blank?
    end

    def execute
      use_action_handlers
      use_alternatives
      use_fallback if !executed?
      self
    end

    def action_handlers
      @action_handlers ||= [:redirect, :render]
    end

    def executed? 
      @executed
    end

    protected

    delegate :command!, to: :controller

    # can be used to set up control logic that fall outside what can be done
    # with the basic action_handlers but can not be considered fall-back.
    def use_alternatives
    end

    def use_fallback  
    end    

    def event
      raise NotImplementedError, 'You must define an #event method that at least returns an event (Symbol). You can use an Executor for this.'
    end

    def fallback_action
      do_redirect root_url
    end

    NoEventsDefinedError    = Controll::FlowHandler::Render::NoEventsDefinedError
    NoRedirectionFoundError = Controll::FlowHandler::Redirect::NoRedirectionFoundError    

    def use_action_handlers
      errors = []
      action_handlers.each do |action_handler|
        begin          
          action_handler_clazz = handler_class(action_handler)
          next unless action_handler_clazz
          action = action_handler_clazz.action(event)
          execute_with action
          return if executed?
        rescue NoEventsDefinedError => e
          errors << e
        rescue NoRedirectionFoundError => e
          errors << e
        end
      end
      raise ActionEventError, "#{errors.join ','}" unless errors.empty?
    end

    def handler_class action_handler
      clazz = "#{self.class}::#{action_handler.to_s.camelize}"
      clazz.constantize
    rescue NameError
      nil
    end

    def execute_with action
      return if !action
      action.perform(controller)
      executed!      
    end

    def executed!
      @executed = true
    end
  end
end