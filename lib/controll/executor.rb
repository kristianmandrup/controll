module Controll
  module Executor
    autoload :Base,         'controll/executor/base'
    autoload :Delegator,    'controll/executor/delegator'
    autoload :Notificator,  'controll/executor/notificator'
  end
end

module Executors
  Base        = Controll::Executor::Base
  Delegator   = Controll::Executor::Delegator
  Notificator = Controll::Executor::Notificator
end