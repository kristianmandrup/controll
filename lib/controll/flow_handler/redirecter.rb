require 'controll/flow_handler/base'

module Controll::FlowHandler
  class Redirecter < Base    
    autoload :Action, 'controll/flow_handler/redirect/action'
    autoload :Mapper, 'controll/flow_handler/redirect/mapper'

    def initialize path
      super path
    end

    def perform controller
      raise BadPathError, "Bad path: #{path}" if path.blank?
      controller.do_redirect controller.send(path)
    end

    class << self
      attr_writer :action_clazz
      attr_reader :types

      def action event
        path = action_clazz.new(event, redirections, types).map
        self.new path unless path.blank?
      end

      # reader
      def redirections_for type = :notice
        @redirections ||= {}
        @redirections[type.to_sym] || {}
      end

      # writer
      # also auto-adds type to types
      def redirections *args, &block
        @redirections ||= {}
        return @redirections if args.empty? && !block_given?

        type = args.first.kind_of?(Symbol) ? args.shift : :notice        
        @redirections[type.to_sym] = block_given? ? yield : args.first
        @types << type unless types.include?(type)
      end 

      protected

      def action_clazz
        @action_clazz ||= Controll::FlowHandler::Redirect::Action
      end
    end
  end
 end