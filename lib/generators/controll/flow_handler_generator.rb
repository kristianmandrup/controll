module Controll
  module Generators
    class FlowHandlerGenerator < ::Rails::Generators::NamedBase
      desc 'Generates a FlowHandler'
      
      def main_flow
        template 'flow_handler.tt', "app/controll/flow_handlers/#{file_name}.rb"
      end

      protected

      def parent_class
        name.include?('::') ? "::Controll::FlowHandler::#{parent_class_name}" : parent_class_name
      end      

      def parent_class_name
        'Control'
      end      
    end
  end
end