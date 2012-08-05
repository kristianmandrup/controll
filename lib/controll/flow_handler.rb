module Controll
  module FlowHandler
    autoload :Base,     'controll/flow_handler/base'
    autoload :Control,  'controll/flow_handler/control'
    autoload :Redirect, 'controll/flow_handler/redirect'
    autoload :Render,   'controll/flow_handler/render'
  end
end