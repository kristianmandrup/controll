module Controll
  module Executor
    class Base
      attr_accessor :initiator, :options

      def initialize initiator, options = {}
        @initiator = initiator
        @options = options
      end
    end
  end
end