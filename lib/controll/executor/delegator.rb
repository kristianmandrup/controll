module Controll
  module Executor
    class Delegator < Base
      def method_missing(meth, *args, &block)
        initiator.send(meth, *args, &block)
      end
    end
  end
end