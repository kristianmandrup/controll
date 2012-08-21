module Controll::Flow
  class Master
    module Macros
      extend ActiveSupport::Concern

      module ClassMethods
        def handler options = {}, &block
          mapper_type = :simple if options[:simple]
          mapper_type ||= :complex if options[:complex]

          master_clazz = Controll::Flow::Master

          unless mapper_type
            raise ArgumentError, "You must specify mapper type, one of: #{master_clazz.mapper_types} in: #{options}" 
          end

          handler_type = options.delete(mapper_type)

          unless master_clazz.valid_handler? handler_type
            raise ArgumentError, "Must one of: #{master_clazz.valid_handlers} was: #{handler_type}"
          end
          
          parent = "Controll::Flow::ActionMapper::#{mapper_type.to_s.camelize}".constantize

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

        def renderer mapper_type = :simple, options = {}, &block
          handler options.merge(mapper_type => :renderer), &block
        end

        def redirecter mapper_type = :complex, options = {}, &block
          handler options.merge(mapper_type => :redirecter), &block
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
      end
    end
  end
end