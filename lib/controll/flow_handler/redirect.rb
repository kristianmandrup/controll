require 'controll/flow_handler/base'

module Controll::FlowHandler
  class Redirect < Base
    class NoRedirectionFoundError < StandardError; end

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
      attr_writer :redirections, :error_redirections

      # event is a Hashie::Mash or simply a Symbol (default notice event)
      def action event
        redirect = nil
        redirect_maps.each do |redirect_map|
          continue unless respond_to? redirect_map # skip any undefined redirect_map
          redirect = handle_map redirect_map, event
          break redirect if redirect
        end
        return redirect unless redirect.blank?
        raise NoRedirectionFoundError, "No redirection could be found for: #{event} in any of #{redirect_maps}"
      end

      def handle_map redirect_map, event
        # note: events can also be a single symbol!
        send(redirect_map).each do |path, events|
          valid = valid_context?(event, events, redirect_map)
          return self.new(path) if valid
        end
      end        

      def valid_context? event, events, redirect_map
         event_match?(events, event) && event_map_match?(event, redirect_map)
      end

      def event_match? events, event
        [events].flatten.include?(event_name_of event)
      end

      # Special - :redirections applies for :notice events
      # :error_redirections applies for :error events and so on
      def event_map_match? event, redirect_map
        type =event_type_of(event)
        (type == :notice && redirect_map == :redirections) || redirect_map.to_s =~/^#{type}/
      end

      def redirect_maps
        [:redirections, :error_redirections]
      end

      def redirections
        {}
      end

      def error_redirections
        {}
      end

      def set_redirections *args, &block
        postfix = args.first if args.first.kind_of?(Symbol)        
        methname = [:redirections, postfix].compact.join('_')
        (class << self; self; end).send :define_method, methname do 
          block_given? ? yield : args.first
        end
      end 

      def set_redirect_maps *args, &block
        (class << self; self; end).send :define_method, :redirect_maps do 
          block_given? ? yield : args.flatten
        end
      end       
    end
  end
 end