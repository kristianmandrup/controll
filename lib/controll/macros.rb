module Controll
  module Macros
    extend ActiveSupport::Concern

    module ClassMethods
      def enable_controll
        clazz = self.ancestors.include?(::Imperator::Command) ? Controll::Focused::Enabler : Controll::Enabler
        self.send :include, clazz
      end
    end
  end
end
