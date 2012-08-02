module MessageHandler
  class Flash
    attr_reader :controller

    def initialize controller
      @controller = controller
      set_options!
    end

    protected

    delegate :flash, to: :controller

    def options
      controller.msg_options
    end

    def signal msg, type = nil
      type ||= signal_type
      flash[type] = msg
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
