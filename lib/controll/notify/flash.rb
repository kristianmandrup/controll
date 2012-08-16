module Controll
  module Notify
    class Flash
      attr_reader :controller

      def initialize controller, options = {}
        @controller = controller
        @options = options if options.kind_of? Hash
      end

      protected

      def options
        @options ||= {}
      end

      delegate :flash, to: :controller

      class << self
        attr_writer :types

        def types
          @types ||= TYPES
        end

        def add_types *types
          @types += types.flatten
        end
        alias_method :add_type, :add_types
      end

      def signal msg, type = nil
        return if msg.blank?
        type ||= signal_type || :notice
        raise ArgumentError, "Unsupported flash type: #{type}. Register via #{self.class.name}#types or #add_type" unless valid_type? type
        flash[type] = msg unless type.blank?
      end

      def valid_type? type
        types.include? type.to_sym
      end

      def types
        self.class.types
      end

      def signal_type
        self.class.signal_type
      end
    end
  end
end