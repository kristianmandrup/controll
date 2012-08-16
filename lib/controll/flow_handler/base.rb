module Controll::FlowHandler
  class Base
    attr_reader :path

    def initialize path
      @path = path.to_s
    end

    def perform controller
      raise NotImplementedError, 'You must implement the #perform method'
    end

    class << self
      def action event
        raise NotImplementedError, 'You must implement the #action class method'
      end
    end
  end
end