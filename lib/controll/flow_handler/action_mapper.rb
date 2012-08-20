module Controll::FlowHandler
  module ActionMapper
    autoload :Action,       'controll/flow_handler/action_mapper/action'
    autoload :PathAction,   'controll/flow_handler/action_mapper/path_action'
    autoload :Fallback,     'controll/flow_handler/action_mapper/fallback'

    autoload :Simple,       'controll/flow_handler/action_mapper/simple'
    autoload :Complex,      'controll/flow_handler/action_mapper/complex'
  end
end
