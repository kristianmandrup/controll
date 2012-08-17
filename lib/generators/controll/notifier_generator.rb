module Controll
  module Generators
    class NotifierGenerator < ::Rails::Generators::NamedBase
      desc 'Generates a Notifier'
      
      def main_flow
        template 'notifier.tt', "app/controll/notifiers/#{file_name}.rb"
      end

      protected

      def parent_class
        name.include?('::') ? "::Controll::Notify::#{parent_class_name}" : parent_class_name
      end      

      def parent_class_name
        'Typed'
      end       
    end
  end
end