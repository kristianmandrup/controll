module Controll
  # used to register commands for a controller
  class Commander
    # makes #command_method available
    extend Imperator::Command::MethodFactory

    attr_reader :initiator, :options

    def initialize initiator, options = {}
      @initiator = initiator
      @options = options
    end

    def command name, *args
      send "#{name}_command", *args
    end

    def command! name, *args
      command(name, *args).perform
    end
    alias_method :use_command, :command!
    alias_method :perform_command, :command!

    alias_method :controller, :initiator

    class << self
      def initiator_methods *names
        delegate names, to: :initiator
      end    
      alias_method :controller_methods, :initiator_methods
    end
  end
end

module Commanders
  Commander = Controll::Commander
end