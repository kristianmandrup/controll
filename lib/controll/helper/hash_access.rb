module Controll::Helper
  module HashAccess
    extend ActiveSupport::Concern

    module ClassMethods
      def hash_access_methods *args
        options = args.extract_options!
        hash_name = options[:hash]
        names = args

        raise ArgumentError, "Must take a :hash option indicating the hash name to access" unless hash_name
        raise ArgumentError, "Must take one or more names of methods to create" if names.blank? 

        names.each do |name|
          define_method name do            
            unless instance_variable_get("@#{name}")
              instance_variable_set "@#{name}", (send(hash_name, name.to_sym) || options[:default])
            end
          end
        end
      end

      alias_method :hash_access_method, :hash_access_methods
    end
  end
end