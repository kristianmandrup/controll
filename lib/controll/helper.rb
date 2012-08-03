require 'controll/messaging'

module Controll
  module Helper
    include Controll::Messaging    
    extend ActiveSupport::Concern

    delegate :command, :command!, :use_command, to: commander

    module ClassMethods
      # TODO: refactor - all use exactly the same pattern - can be generated!
      def commander name, options = {}
        define_method :commander do
          unless instance_variable_get("@commander")
            clazz = "#{name.to_s.camelize}Commander".constantize        
            instance_variable_set "@commander", clazz.new self, options
          end
        end
      end

      def message_handler name, options = {}
        define_method :message_handler do
          unless instance_variable_get("@message_handler")
            clazz = "#{name.to_s.camelize}MessageHandler".constantize        
            instance_variable_set "@message_handler", clazz.new self, options
          end
        end
      end

      def assistant name, options = {}
        define_method :assistant do
          unless instance_variable_get("@assistant")
            clazz = "#{name.to_s.camelize}Assistant".constantize        
            instance_variable_set "@assistant", clazz.new self, options
          end
        end
      end

      def flow_handler name, options = {}
        define_method :flow_handler do
          unless instance_variable_get("@flow_handler")
            clazz = "FlowHandler::#{name.to_s.camelize}".constantize        
            instance_variable_set "@flow_handler", clazz.new self, options
          end
        end
      end

      def delegate_assistant name, options = {}
        define_method :assistant do
          unless instance_variable_get("@assistant")
            clazz = "#{name.to_s.camelize}DelegateAssistant".constantize        
            instance_variable_set "@assistant", clazz.new self, options
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
      [path, options] = arg_resolver.extract_args :redirect_map, *args
      process_notifications
      redirect_to path, *args
    end

    def do_render *args
      options = args.extract_options!
      path = arg_resolver.extract_path :render_paths, *args
      process_notifications
      render path. *args
    end

    protected

    def arg_resolver
      @arg_resolver ||= ArgResolver.new self
    end

    class PathResolver
      attr_reader :caller

      def initialize caller
        @caller = caller
      end

      def extract_args type, *args
        if args.first.kind_of?(Symbol)
          parent.notice args.first
          resolve_path type
        else      
          args.empty? ? resolve_path(type) : args.first
        end
      end

      def resolve_path type
        send(type).each do |path, events|
          return path if events.include? main_event
        end
      end
    end
  end
end