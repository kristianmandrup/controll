module Controll
  module Helper
    include Messaging

    def do_redirect path
      notify!
      redirect_to path
    end

    def do_render path
      notify!
      render path
    end
  end
end