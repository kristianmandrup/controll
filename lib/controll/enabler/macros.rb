module Controll
  module Enabler
    module Macros
      extend ActiveSupport::Concern

      module ClassMethods

        # on Controller: 
        #  - fx Admin::ServicesController -> :services
        # On Focused Controller action: 
        #  - fx Admin::ServicesController::Update -> :update_services
        def controll *artifacts
          def name_of clazz
            clazz = clazz.to_s
            if clazz =~ /Controller$/
              clazz.sub(/Controller$/, '').split('::').last.underscore
            else
              parts = clazz.sub(/Controller/, '').split('::')
              (parts.pop << parts.last).underscore
            end
          end

          options = artifacts.extract_options!
          name = name_of self.class
          artifacts.each do |artifact|
            send(artifact, name, options)
          end
        end

        # TODO: refactor - all use exactly the same pattern - can be generated!
        def commander name, options = {}
          define_method :commander do
            instance_variable_get("@commander") || begin
              clazz = "Commanders::#{name.to_s.camelize}".constantize        
              instance_variable_set "@commander", clazz.new(self, options)
            end
          end
        end

        def notifier name, options = {}
          define_method :notifier do
            instance_variable_get("@notifier") || begin
              clazz = "Notifiers::#{name.to_s.camelize}".constantize        
              instance_variable_set "@notifier", clazz.new(self, options)
            end
          end
        end

        def flow name, options = {}
          define_method :flow do
            unless instance_variable_get("@flow")
              clazz = "Flows::#{name.to_s.camelize}".constantize        
              instance_variable_set "@flow", clazz.new(self, options)
            end
          end
        end

        def assistant name, options = {}
          define_method :assistant do
            unless instance_variable_get("@assistant")
              clazz = "Assistants::#{name.to_s.camelize}".constantize        
              instance_variable_set "@assistant", clazz.new(self, options)
            end
          end
        end

        def assistant_methods *names
          options = names.extract_options!
          assistant = options[:to] || :assistant
          delegate names, to: assistant
        end        
      end
    end
  end
end