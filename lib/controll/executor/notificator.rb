require 'controll/executor/base'

module Controll::Executor
  class Notificator < Delegator

    # return last notification or :success as result
    # return <Event>
    def result
      main_event
    end
  end
end
