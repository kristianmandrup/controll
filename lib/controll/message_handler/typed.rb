require 'controll/message_handler/flash'

module MessageHandler
  class Typed < Flash
    def error
      raise "ErrorMsg class missing for this message handler" unless ErrorMsg
      @error ||= ErrorMsg.new flash, options
    end

    def notice
      raise "NoticeMsg class missing for this message handler" unless NoticeMsg
      @notice ||= NoticeMsg.new flash, options
    end
  end
end
