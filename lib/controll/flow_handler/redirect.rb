require 'controll/flow_handler/base'

module FlowHandler
  class Redirect < Base
    def initialize path, maps = nil
      super path

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

      # event.name
      # event.type
      def action event
        redirect_maps.each do |redirect_map|
          continue unless respond_to? redirect_map # skip any undefined redirect_map
          handle_map redirect_map, event
        end
        nil
      end

      def handle_map redirect_map, event
        # note: events can also be a single symbol!
        send(redirect_map).each do |path, events|
          return self.new(path) if valid_context?(event, [events].flatten, redirect_map)
        end
      end        

      def valid_context? event, events, redirect_map
        events.include?(event.name) && event_map_match?(event, redirect_map)
      end

      # Special - :redirections applies for :notice events
      # :error_redirections applies for :error events and so on
      def event_map_match? event, redirect_map
        (event.type == :notice && redirect_map == :redirections) || redirect_map.to_s =~/^#{event.type}/
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
    end
  end
 end