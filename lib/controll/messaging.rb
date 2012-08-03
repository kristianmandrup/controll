module Controll
  module Messaging
    # msg stack
    def notifications
      @notifications ||= []
    end

    def notify name, *args
      options = args.extract_options!
      type = args.first || :notify
      notifications << Hashie::Mash.new(name: name, type: type, options: options)
    end

    def error name, options = {}
      notify name, :error, options
    end
    
    def notify!
      notifications.each do |message|
        msg_handler.send(message.type).notify message.name, message.options
      end
    end
  end
end