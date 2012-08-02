require 'controll/message_handler/flash'

module MessageHandler
  class Notify < Flash
    def notify name, options = {}
      self.options.merge! options
      send(name)
    end

    class << self
      attr_reader :signal_type

      def type name
        @signal_type = name
      end
    end
  end
end
