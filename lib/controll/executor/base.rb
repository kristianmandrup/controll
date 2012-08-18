module Controll
  module Executor
    class Base
      attr_accessor :controller, :options

      def initialize controller, options = {}
        @controller = controller
        @options = options
      end
    end
  end
end