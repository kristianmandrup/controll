module Controll::FlowHandler
  class Control
    module Macros
      extend ActiveSupport::Concern

      module ClassMethods
        def handler response_type, options = {}, &block
          unless [:render, :repsonse].include? response_type.to_sym
            raise ArgumentError, "Must be either :render or :response" 
          end

          clazz_name = "#{parent}::#{response_type.to_s.camelize}"
          parent = options[:parent] || "Controll::FlowHandler::#{response_type}".constantize

          clazz = parent ? Class.new(parent) : Class.new
          Object.const_set clazz_name, clazz
          context = self.kind_of?(Class) ? self : self.class
          clazz = context.const_get(clazz_name)

          clazz.instance_eval(&block) if block_given?
          clazz
        end

        def renderer options = {}, &block
          handler :renderer, options = {}, &block
        end

        def redirecter options = {}, &block
          handler :redirecter, options = {}, &block
        end

        def event &block
          raise ArgumentError, "Must be called with a block" unless block_given?
          define_method :event do
            instance_variable_get("@event") || instance_variable_set("@event", instance_eval(&block))
          end
        end

        def fallback &block
          raise ArgumentError, "Must be called with a block" unless block_given?
          define_method(:fallback, &block)
        end

        def action_handlers *names, &block
          raise ArgumentError, "Must be called with names of action handlers" if names.empty?
          define_method :action_handlers do
            value = block_given? ? instance_eval(&block) : names.flatten
            instance_variable_get("@action_handlers") || instance_variable_set("@action_handlers", value)
          end
        end
      end
    end
  end
end