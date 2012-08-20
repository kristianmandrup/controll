module Controll::FlowHandler
  class ActionEventError          < StandardError; end
  
  class PathActionError           < StandardError; end

  # Redirect
  class NoRedirectionFoundError   < PathActionError; end

  # Render
  class NoEventsDefinedError      < PathActionError; end
  class NoDefaultPathDefinedError < PathActionError; end
  
  class BadPathError              < PathActionError; end
end
