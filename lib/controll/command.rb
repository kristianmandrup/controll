module Controll
  class Command < Imperator::Command
    protected

    delegate :session, :params, :notify, :error, :do_redirect, :do_render, to: :initiator

    alias_method :redirect, :do_redirect
    alias_method :render, :do_render
  end
end