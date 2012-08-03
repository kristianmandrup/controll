module Controll
  module HashAccessHelper
    extend ActiveSupport::Concern

    module ClassMethods
      def hash_access_methods *args
        options = args.extract_options!
        hash_name = options[:hash]
        names.each do |name|

        value = send(hash_name)
        methname = name
        if name.kind_of?(Array)
          name.each {|n| value = value[n] } 
          methname = name.join('_')
        end

        define_method methname do            
          unless instance_variable_get("@#{methname}")                          
            instance_variable_set "@#{methname}", value
          end
        end
      end
      alias_method :param_method, :param_methods
    end
  end
end
