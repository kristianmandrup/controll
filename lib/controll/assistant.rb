module Controll
  class Assistant
    attr_reader :controller, :options

    def initialize controller, options = {}
      @controller = controller
      @options = options
    end

    def self.controller_methods *names
      delegate names, to: :controller
    end
  end
end

module Assistants
  Assistant = Controll::Assistant
end