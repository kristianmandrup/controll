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

    def self.commands *methods
      methods.each { |meth| command_method meth }
    end

    # what to delegate to controller
    def self.controller_methods
      delegate :auth_hash, :user_id, :service_id, :service_hash, :to => :controller
    end
  end
end