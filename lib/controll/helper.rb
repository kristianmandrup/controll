require 'controll/messaging'

module Controll
  module Helper
    include Controll::Messaging
    extend Imperator::Command::MethodFactory

    include ActiveSupport::Concern

    module ClassMethods
      def commands *methods
        methods.each { |meth| command_method meth }
      end
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