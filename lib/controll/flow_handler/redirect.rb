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
        return unless event_name_of(event)
        mm = matching_maps(event)
        mm.each do |redirect_map|
          continue unless respond_to?(redirect_map)
          redirect = handle_map redirect_map, event
          return redirect unless redirect.blank?
        end
        raise NoRedirectionFoundError, "No redirection could be found for: #{event} in any of #{mm}"
      end

      def matching_maps event
        redirect_maps.select {|map| event_map_match?(event, map) }
      end

      # An events can also be a Symbol,
      # in which case it is a :notice event
      def handle_map redirect_map, event
        send(redirect_map).each do |path, events|
          valid = event_match?(events, event)
          return self.new(path) if valid
        end
        nil
      end        

      def event_match? events, event
        normalize(events).include?(event_name_of event)
      end

      def normalize events
        [events].flatten.map(&:to_sym)
      end

      # Special - :redirections applies for :notice events
      # :error_redirections applies for :error events and so on
      def event_map_match? event, map
        type = event_type_of(event)
        (type == :notice && map == :redirections) || map.to_s =~/^#{type}/
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
        postfix = args.shift if args.first.kind_of?(Symbol)        
        methname = [postfix, :redirections].compact.join('_')
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