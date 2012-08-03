module Controll
  module ParamsHelper 
    extend Controll::HashAccessHelper

    module ClassMethods
      def param_methods *names
        hash_access_method *names, hash: :params
      end
      alias_method :param_method, :param_methods
    end
  end
end
