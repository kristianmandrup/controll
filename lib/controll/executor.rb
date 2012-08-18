module Controll
  module Executor
    autoload :Base,         'controll/executor/base'
    autoload :Controlled,   'controll/executor/controlled'
    autoload :Delegator,    'controll/executor/delegator'
  end
end

module Executors
  Base        = Controll::Executor::Base
  Delegator   = Controll::Executor::Delegator
  Controlled  = Controll::Executor::Controlled
end