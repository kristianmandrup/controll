module Controll
  module Helper
    autoload :Notify,       'controll/helper/notify'
    autoload :HashAccess,   'controll/helper/hash_access'
    autoload :Params,       'controll/helper/params'
    autoload :Session,      'controll/helper/session'
    autoload :PathResolver, 'controll/helper/path_resolver'
    autoload :EventMatcher, 'controll/helper/event_matcher'

    include Controll::Helper::Notify
    include Controll::Helper::Params

    extend ActiveSupport::Concern

    delegate :command, :command!, :use_command, to: :commander

    module ClassMethods
      # TODO: refactor - all use exactly the same pattern - can be generated!
      def commander name, options = {}
        define_method :commander do
          instance_variable_get("@commander") || begin
            clazz = "Commanders::#{name.to_s.camelize}".constantize        
            instance_variable_set "@commander", clazz.new(self, options)
          end
        end
      end

      def message_handler name, options = {}
        define_method :message_handler do
          instance_variable_get("@message_handler") || begin
            clazz = "Notifiers::#{name.to_s.camelize}".constantize        
            instance_variable_set "@message_handler", clazz.new(self, options)
          end
        end
      end

      def assistant name, options = {}
        define_method :assistant do
          unless instance_variable_get("@assistant")
            clazz = "Assistants::#{name.to_s.camelize}".constantize        
            instance_variable_set "@assistant", clazz.new(self, options)
          end
        end
      end

      def flow_handler name, options = {}
        define_method :flow_handler do
          unless instance_variable_get("@flow_handler")
            clazz = "FlowHandlers::#{name.to_s.camelize}".constantize        
            instance_variable_set "@flow_handler", clazz.new(self, options)
          end
        end
      end

      def redirect_map map = {}
        @redirect_map ||= map
      end

      def render_map map = {}
        @render_map ||= map
      end
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