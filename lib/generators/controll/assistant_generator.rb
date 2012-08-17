module Controll
  module Generators
    class AssistantGenerator < ::Rails::Generators::NamedBase
      desc 'Generates an Assitant'
      
      class_option :delegate, type: :boolean, default: false

      def main_flow
        template "assistant.tt", "app/controll/assistants/#{file_name}.rb"
      end

      protected

      def delegate?
        options[:delegate]
      end

      def parent_class
        name.include?('::') ? "::Controll::#{parent_class_name}" : parent_class_name
      end

      def parent_class_name
        delegate? 'DelegateAssistant' : 'Assistant'        
      end
    end
  end
end