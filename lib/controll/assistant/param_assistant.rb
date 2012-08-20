module Controll
  class ParamAssistant < Assistant
    include Controll::Helper::Params

    controller_methods :params

    module Helper
      extend ActiveSupport::Concern

      def param name
        param_assistant.send(name)
      end

      module ClassMethods
        def param_assistant clazz
          define_method :param_assistant do
            @param_assistant ||= clazz.new self
          end
        end
      end
    end
  end
end