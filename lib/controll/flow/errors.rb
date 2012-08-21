module Controll::Flow
  class ActionEventError          < StandardError; end

  class EventNotImplementedError  < StandardError; end
  
  class PathActionError           < StandardError; end

  # Complex mapper
  class NoMappingFoundError   < PathActionError; end

  # Simple mapper
  class NoEventsDefinedError      < PathActionError; end
  class NoDefaultPathDefinedError < PathActionError; end
  
  class BadPathError              < PathActionError; end
end
