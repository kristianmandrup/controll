require 'controll/flow_handler/base'

module Controll::FlowHandler
  class Redirecter < ActionHandler
    autoload :Action, 'controll/flow_handler/redirect/action'
    autoload :Mapper, 'controll/flow_handler/redirect/mapper'

    def controller_action
      :do_redirect
    end

    class << self
      attr_writer :action_clazz
      attr_reader :types

      # this method could be generated whenever a class inherits from ActionHandler class?
      def inherited base
        if base.parent.respond_to? :add_action_handler
          base.add_action_handler self.name.demodulize
        end
      end

      def action event
        path = action_clazz.new(event, redirections, types).map
        self.new controller, path unless path.blank?
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
        @action_clazz ||= Controll::FlowHandler::Redirecter::Action
      end
    end
  end
 end