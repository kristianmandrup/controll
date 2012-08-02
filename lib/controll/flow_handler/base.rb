module FlowHandler
  class Base
    attr_reader :path

    def initialize path
      @path = path
    end

    def perform controller
      raise NotImplementedError, 'You must implement the #perform method'
    end

    def self.action event
      raise NotImplementedError, 'You must implement the #action class method'
    end
  end
 end