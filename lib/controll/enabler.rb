module Controll
  module Enabler
    autoload :Notify,       'controll/helper/notify'
    autoload :HashAccess,   'controll/helper/hash_access'
    autoload :Params,       'controll/helper/params'
    autoload :Session,      'controll/helper/session'
    autoload :PathResolver, 'controll/helper/path_resolver'
    autoload :EventMatcher, 'controll/helper/event_matcher'

    include Controll::Helper::Notify
    include Controll::Helper::Params
    
    include Controll::Enabler::Macros

    delegate :command, :command!, :use_command, to: :commander

    extend ActiveSupport::Concern

    module ClassMethods
      def redirect_map map = {}
        @redirect_map ||= map
      end

      def render_map map = {}
        @render_map ||= map
      end

      def assistant_methods *names
        options = names.extract_options!
        assistant = options[:to] || :assistant
        delegate names, to: assistant
      end      
    end

    # override this for custom Controller specific fallback action
    def do_fallback event
      do_redirect root_url
    end    

    def do_redirect *args
      options = args.extract_options!
      path = path_resolver.extract_path(:redirect_map, *args)
      process_notifications
      redirect_to path, *args
    end

    def do_render *args
      options = args.extract_options!
      path = path_resolver.extract_path :render_paths, *args
      process_notifications
      render path, *args
    end

    protected

    def redirect_map
      self.class.redirect_map
    end

    def render_paths
      self.class.render_map
    end

    def path_resolver
      @path_resolver ||= PathResolver.new self
    end
  end
end