module Controll::Flow
  module ActionMapper
    autoload :Action,       'controll/flow/action_mapper/action'
    autoload :PathAction,   'controll/flow/action_mapper/path_action'
    autoload :Fallback,     'controll/flow/action_mapper/fallback'

    autoload :Simple,       'controll/flow/action_mapper/simple'
    autoload :Complex,      'controll/flow/action_mapper/complex'
  end
end
