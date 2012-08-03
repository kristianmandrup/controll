require 'controll/executor/base'

module Executor
  class Notificator < Base
    # return last notification or :success as result
    # Hashie::Mash.new(name: name, type: type, options: options)
    def result
      notifications.last || create_notice(:success)
    end
  end
end
