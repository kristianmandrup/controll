module Controll
  autoload :SessionAssistant, 'controll/assistant/session_assistant'
  autoload :ParamAssistant,   'controll/assistant/param_assistant'

  class Assistant
    attr_reader :controller, :options

    def initialize controller, options = {}
      @controller = controller
      @options = options
    end

    def self.controller_methods *names
      delegate *names, to: :controller
    end
  end
end

module Assistants
  Assistant = Controll::Assistant
end