module Controll
  class Command < ::Imperator::Command
    module Delegation
      extend ActiveSupport::Concern

      included do
        delegate :session, :params, :notify, :error, :do_redirect, :do_render, to: :initiator

        alias_method :redirect, :do_redirect
        alias_method :render, :do_render
      end
    end

    include Delegation    
  end

  if defined?(::Mongoid)
    module Mongoid
      class Command < ::Imperator::Mongoid::Command
        include Controll::Command::Delegation
      end
    end
  end
end