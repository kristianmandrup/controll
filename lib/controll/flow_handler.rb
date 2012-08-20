require 'controll/flow_handler/errors'

module Controll
  module FlowHandler
    autoload :Master,         'controll/flow_handler/master'
    autoload :EventMapper,    'controll/flow_handler/event_mapper'    
    autoload :ActionMapper,   'controll/flow_handler/action_mapper'
  end
end

module FlowHandlers
  Master      = Controll::FlowHandler::Master
end