module Controll::FlowHandler
  class ActionEventError          < StandardError; end
  
  # Redirect
  class NoRedirectionFoundError   < StandardError; end

  # Render
  class NoEventsDefinedError      < StandardError; end
  class NoDefaultPathDefinedError < StandardError; end
  class BadPathError              < StandardError; end
end
