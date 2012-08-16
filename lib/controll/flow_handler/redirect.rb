require 'controll/flow_handler/base'

module Controll::FlowHandler
  class Redirect < Base    
    autoload :Action, 'controll/flow_handler/redirect/action'
    autoload :Mapper, 'controll/flow_handler/redirect/mapper'

    def initialize path
      super path
    end

    def perform controller
      controller.do_redirect controller.send(path)
    end

    class << self
      attr_accessor :redirections
      attr_writer   :redirect_maps, :action_clazz

      def action event
        path = action_clazz.new(event, redirections, types).map
        self.new path unless path.blank?
      end

      def types
        @types ||= [:notice, :error]
      end

      def redirections_for type = :notice
        @redirections ||= {}
        @redirections[type.to_sym] || {}
      end

      def set_redirections *args
        type = args.first.kind_of?(Symbol) ? args.shift : :notice
        @redirections ||= {}
        @redirections[type.to_sym] = args.first
      end 

      def set_types *names
        @redirect_maps ||= names.flatten
      end  

      protected

      def action_clazz
        @action_clazz ||= Controll::FlowHandler::Redirect::Action
      end
    end
  end
 end