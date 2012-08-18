require 'controll/flow_handler/errors'

module Controll
  module FlowHandler
    autoload :Base,         'controll/flow_handler/base'
    autoload :Master,       'controll/flow_handler/master'
    autoload :Redirecter,   'controll/flow_handler/redirecter'
    autoload :Renderer,     'controll/flow_handler/renderer'    
    autoload :Fallback,     'controll/flow_handler/fallback'        
    autoload :EventHelper,  'controll/flow_handler/event_helper'    
  end
end

module FlowHandlers
  Base    = Controll::FlowHandler::Base
  Master  = Controll::FlowHandler::Master
end