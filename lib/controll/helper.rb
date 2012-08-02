require 'controll/messaging'

module Controll
  module Helper
    include Controll::Messaging
    extend Imperator::Command::MethodFactory

    include ActiveSupport::Concern

    included do
      commands.each {|command| command_method command} if commands && commands.kind_of?(Array)
    end

    def do_redirect path
      notify!
      redirect_to path
    end

    def do_render path
      notify!
      render path
    end
  end
end