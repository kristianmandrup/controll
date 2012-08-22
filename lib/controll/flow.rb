require 'controll/flow/errors'

module Controll
  module Flow
    autoload :Master,         'controll/flow/master'
    autoload :Action,         'controll/flow/action'
    autoload :EventMapper,    'controll/flow/event_mapper'    
    autoload :ActionMapper,   'controll/flow/action_mapper'
  end
end

module Flows
  Master      = Controll::Flow::Master
  Flow        = Controll::Flow::Master
end