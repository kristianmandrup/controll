module Controll
  module Helper
    module Params 
      extend Controll::Helper::HashAccess

      module ClassMethods
        def param_methods *args
          options = args.extract_options!
          names = args
          hash_access_method *names, options.merge(hash: :params)
        end

        def param_method name, options = {}
          hash_access_method name, options.merge(hash: :params)
        end
      end
    end
  end
end