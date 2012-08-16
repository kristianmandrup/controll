module Controll::FlowHandler
  class NoRedirectionFoundError < StandardError; end
  class NoEventsDefinedError < StandardError; end
  class BadPathError < StandardError; end
end