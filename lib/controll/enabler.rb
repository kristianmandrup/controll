module Controll
  module Enabler
    autoload :Macros,         'controll/enabler/macros'
    autoload :Notify,         'controll/enabler/notify'
    autoload :PathResolver,   'controll/enabler/path_resolver'
    autoload :PathHandler,    'controll/enabler/path_handler'
    autoload :Maps,           'controll/enabler/maps'

    extend ActiveSupport::Concern

    included do      
      include Controll::Helper::Params
      include Controll::Helper::Session

      include Notify
      include Macros
      include Maps

      delegate :command, :command!, :use_command, to: :commander
    end

    # override this for custom Controller specific fallback action
    def do_fallback action
      do_redirect fallback_path
    end    

    def do_redirect *args
      redirecter.execute *args
    end

    def do_render *args
      renderer.execute *args
    end    

    protected

    def fallback_path
      root_url
    end

    def renderer
      @renderer||= PathHandler.new self, :render
    end

    def redirecter
      @redirecter ||= PathHandler.new self, :redirect
    end
  end
end