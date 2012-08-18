require 'controll/executor/base'

module Controll::Executor
  class Controlled < Delegator

    def execute
      validations
      do_command unless error?
    end

    # return last notification or :success as result
    # return <Event>
    def result
      main_event
    end

    class << self
      def execute &block
        define_method :execute do
          super
          instance_eval &block
          result
        end
      end
    end

    protected

    def validations
    end

    def error?
      notifications.error?
    end
  end
end
