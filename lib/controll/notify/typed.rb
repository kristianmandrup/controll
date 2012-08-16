require 'controll/notify/flash'

module Controll
  module Notify
    class Typed < Flash
      class MissingNotifyHandlerClass < StandardError; end

      include Controll::Notify::Macros

      types.each do |type|      
        define_method type do        
          clazz = handler_class(type)
          raise MissingNotifyHandlerClass, "#{clazz} class missing" unless clazz
          var = "@#{type}"
          instance_variable_get(var) || instance_variable_set(var, clazz.new flash)
        end
      end

      protected

      def handler_class name
        handler_classes[name] ||= "#{self.class}::#{name.to_s.camelize}Handler".constantize
      end 

      def handler_classes
        @handler_classes ||= {}
      end
    end
  end
end