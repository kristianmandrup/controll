module Controll
  class SessionAssistant < Assistant
    include Controll::Helper::Session

    controller_methods :session

    module Helper
      extend ActiveSupport::Concern

      def sess name
        session_assistant.send(name)
      end

      module ClassMethods
        def session_assistant clazz
          define_method :session_assistant do
            @session_assistant ||= clazz.new self
          end
        end
      end
    end
  end
end