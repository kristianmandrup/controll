module Controll
  module Generators
    class ExecutorGenerator < ::Rails::Generators::NamedBase
      desc 'Generates an Executor'

      class_option :type, default: 'base', desc: 'The type of executor' 
      
      def main_flow
        template 'executor.tt', "app/controll/executors/#{file_name}.rb"
      end

      protected

      def parent_class
        name.include?('::') ? "::Controll::Executor::#{parent_class_name}" : parent_class_name
      end      

      def parent_class_name
        (options[:type] || 'base').camelize
      end
    end
  end
end