require 'controll/flow_handler/base'

module Controll::FlowHandler
  class Redirect < Base
    class NoRedirectionFoundError < StandardError; end

    autoload :Action, 'controll/flow_handler/redirect/action'

    def initialize path, maps = nil
      super path
      return if maps.blank?

      # try to set redirect mappings if passed as 2nd arg
      class_eval do
        redirect_maps.each do |name|
          send("#{name}=", maps[name]) if send(name)
        end
      end
    end

    def perform controller
      controller.do_redirect controller.send(path)
    end

    class << self
      attr_writer :redirections, :redirect_maps

      def action event
        Action.new(event).create
      end

      def redirect_maps
        @redirect_maps ||= [:notice, :error]
      end

      def redirections type = :notice
        @redirections ||= {}
        @redirections[type.to_sym] || {}
      end

      def set_redirections *args
        type = args.first.kind_of?(Symbol) ? args.shift : :notice
        @redirections ||= {}
        @redirections[type.to_sym] = args.first
      end 

      def set_redirect_maps *args, &block
        (class << self; self; end).send :define_method, :redirect_maps do 
          block_given? ? yield : args.flatten
        end
      end       
    end
  end
 end