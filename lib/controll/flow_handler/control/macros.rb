module Controll::FlowHandler
  class Control
    module Macros
      extend ActiveSupport::Concern

      module ClassMethods
        def handler handler_type, options = {}, &block
          unless valid_handlers.include? handler_type.to_sym
            raise ArgumentError, "Must one of: #{valid_handlers} was: #{handler_type}"
          end
          
          parent = options[:parent] || "Controll::FlowHandler::#{response_type.to_s.camelize}".constantize

          clazz_name = handler_type.to_s.camelize
          context = self.kind_of?(Class) ? self : self.class

          clazz = parent ? Class.new(parent) : Class.new
          context.const_set clazz_name, clazz          
          clazz = context.const_get(clazz_name)

          container_class_name = clazz.name.sub(/\.*(::\w+)$/, '')          
          container_class = container_class_name.constantize
          container_class.add_action_handler clazz.name.demodulize

          clazz.instance_eval(&block) if block_given?
          clazz
        end

        def renderer options = {}, &block
          handler :renderer, options = {}, &block
        end

        def fallback options = {}, &block
          handler :fallback, options = {}, &block
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

        # def set_action_handlers *names, &block
        #   raise ArgumentError, "Must be called with names of action handlers" if names.empty?

        #   define_method :action_handlers do
        #     value = block_given? ? instance_eval(&block) : names.flatten
        #     instance_variable_get("@action_handlers") || instance_variable_set("@action_handlers", value)
        #   end
        # end

        def valid_handlers
          [:renderer, :redirecter, :fallback]
        end
      end
    end
  end
end