module Controll::Flow
  module ActionMapper
    autoload :Base,      'controll/flow/action_mapper/base'
    autoload :Simple,    'controll/flow/action_mapper/simple'
    autoload :Complex,   'controll/flow/action_mapper/complex'
  end
end
