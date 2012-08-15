module Controll
  module Executor
    class Base
      attr_accessor :initiator, :options

      def initialize initiator, options = {}
        @initiator = initiator
        @options = options
      end

      def method_missing(meth, *args, &block)
        initiator.send(meth, *args, &block)
      end
    end
  end
end