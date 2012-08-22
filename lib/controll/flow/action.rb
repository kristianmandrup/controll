module Controll::Flow
  module Action
    autoload :Base,         'controll/flow/action/base'
    autoload :PathAction,   'controll/flow/action/path_action'
    autoload :Fallback,     'controll/flow/action/fallback'
  end
end