module MessageHandler
  class Flash
    attr_reader :controller

    def initialize controller
      @controller = controller
      set_options!
    end

    protected

    delegate :flash, to: :controller

    class << self
      attr_writer :types

      def types
        @types ||= [:notice, :error]
      end

      def add_types *types
        types << types
      end
      alias_method :add_type, :add_types
    end

    def options
      controller.msg_options
    end

    def signal msg, type = nil
      return if msg.blank?
      type ||= signal_type
      raise ArgumentError, "Unsupported flash type: #{type}. Register via MessageHandler::Flash#types or #add_type" unless types.include? type.to_sym
      flash[type] = msg unless type.blank?
    end

    def signal_type
      self.class.signal_type
    end

    def set_options!
      # create instance method for each msg option
      case options
      when Hash
        options.each do |key, value|
          self.class.define_method key do
            value
          end
        end
      when Array
        options.each do |meth|
          self.class.define_method meth do
            send(meth)
          end
        end
      end
    end            
  end
end
