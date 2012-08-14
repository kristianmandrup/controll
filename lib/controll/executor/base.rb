module Controll
  module Executor
    class Base
      attr_accessor :initiator

      def initialize initiator
        @initiator = initiator
      end

      def method_missing(meth, *args, &block)
        initiator.send(meth, *args, &block)
      end
    end
  end
end