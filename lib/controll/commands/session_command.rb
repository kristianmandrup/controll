class SessionCommand < Imperator::Command
  attribute :initiator, Object

  protected

  delegate :session, :notify, :error, :do_redirect, :do_render, to: :initiator

  alias_method :redirect, :do_redirect
  alias_method :render, :do_render
end
