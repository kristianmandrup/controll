module Controll
  module Helper
    module Session
      extend ActiveSupport::Concern
      include Controll::Helper::HashAccess

      module ClassMethods
        def session_methods *args
          options = args.extract_options!
          names = args
          hash_access_method *names, options.merge(hash: :session)
        end
        
        def session_method name, options = {}
          hash_access_method name, options.merge(hash: :session)
        end
      end
    end
  end
end