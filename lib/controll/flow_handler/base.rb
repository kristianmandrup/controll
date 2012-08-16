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
      # any subclass of Base should have an inherited(base) class method added
      # which adds itself to the list of action_handler which the parent class 
      # (i.e class that subclass is contained in!) supports
      def inherited(base)
        (class << self; self; end).send :define_method, :inherited do |base|
          base.parent.add_action_handler self.name.demodulize
        end
      end

      def action event
        raise NotImplementedError, 'You must implement the #action class method'
      end
    end
  end
end