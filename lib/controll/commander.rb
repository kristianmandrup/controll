module Controll
  # used to register commands for a controller
  class Commander
    # makes #command_method available
    extend Imperator::Command::MethodFactory

    attr_reader :controller, :options

    def initialize controller, options = {}
      @controller = controller
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
  end
end

module Commanders
  Commander = Controll::Commander
end