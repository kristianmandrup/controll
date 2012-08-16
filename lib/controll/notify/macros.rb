module Controll::Notify
  module Macros
    extend ActiveSupport::Concern

    module ClassMethods
      def handler type, options = {}, &block
        unless valid_type? type
          raise ArgumentError, "Notification type must be any of: #{types}, was: #{type}" 
        end

        clazz_name = "#{parent}::#{type.to_s.camelize}Handler"
        parent = options[:parent] || Controll::Notify::Base

        clazz = parent ? Class.new(parent) : Class.new
        Object.const_set clazz_name, clazz
        context = self.kind_of?(Class) ? self : self.class
        clazz = context.const_get(clazz_name)

        if block_given?
          clazz.instance_eval &block      
        end
        clazz
      end

      def messages hash = nil, &block
        unless block_given? || !hash.blank?
          raise ArgumentError, "Must be called with non-empty Hash or block" 
        end

        define_method :messages do
          block_given? ? instance_eval(&block) : hash
        end
      end

      def message event_name, text = nil, &block
        unless event_name.kind_of?(Symbol) || event_name.kind_of?(String)
          raise ArgumentError, "First argument must be an event name, was: #{event_name}"
        end
        
        unless block_given? || !text.blank?
          raise ArgumentError, "Must be called with non-empty String or block" 
        end
       
        define_method event_name do
          block_given? ? instance_eval(&block) : hash
        end
      end
      alias_method :msg, :message

      protected

      def valid_type? type
        types.include? type.to_sym
      end
    end
  end
end