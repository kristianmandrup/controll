module Controll
  module Generators
    class FlowGenerator < ::Rails::Generators::NamedBase
      desc 'Generates a Flow'
      
      def main_flow
        template 'flow.tt', "app/controll/flows/#{file_name}.rb"
      end

      protected

      def parent_class
        name.include?('::') ? "::Controll::Flow::#{parent_class_name}" : parent_class_name
      end      

      def parent_class_name
        'Control'
      end      
    end
  end
end