module Controll::FlowHandler
  class Base
    attr_reader :path, :controller

    def initialize controller, path
      @controller = controller
      @path = path.to_s
    end

    class << self
      def action event
        raise NotImplementedError, 'You must implement the #action class method'
      end
    end
  end
end