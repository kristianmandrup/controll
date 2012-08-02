class SessionCommand < Imperator::Command
  attribute :initiator, Object

  protected

  delegate :session, :notify, to: :initiator
end
