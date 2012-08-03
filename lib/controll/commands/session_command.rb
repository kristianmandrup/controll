class SessionCommand < Imperator::Command
  attribute :initiator, Object

  protected

  delegate :session, :notify, :error, to: :initiator
end
