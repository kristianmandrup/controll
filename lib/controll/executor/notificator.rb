require 'controll/executor/base'

module Controll::Executor
  class Notificator < Delegator

    # return last notification or :success as result
    # Hashie::Mash.new(name: name, type: type, options: options)
    def result
      main_event
    end
  end
end
