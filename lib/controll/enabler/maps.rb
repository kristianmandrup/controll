module Controll::Enabler
  module Maps
    extend ActiveSupport::Concern

    module ClassMethods
      def redirect_map map = {}
        @redirect_map ||= map
      end

      def render_map map = {}
        @render_map ||= map
      end
    end
  end
end