require 'controll/flow_handler/errors'

module Controll
  module FlowHandler
    autoload :Base,         'controll/flow_handler/base'
    autoload :Control,      'controll/flow_handler/control'
    autoload :Redirecter,   'controll/flow_handler/redirecter'
    autoload :Renderer,     'controll/flow_handler/renderer'    
    autoload :EventHelper,  'controll/flow_handler/event_helper'    
  end
end

module FlowHandlers
  Base    = Controll::FlowHandler::Base
  Control = Controll::FlowHandler::Control
end