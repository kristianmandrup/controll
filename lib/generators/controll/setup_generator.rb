module Controll
  module Generators
    class SetupGenerator < ::Rails::Generators::Base
      desc 'Sets up a Rails 3 prooject with a folder structure in app for controll artifacts'

      argument :folders, type: :array, required: false, desc: 'creates specific folders for controll artifacts'

      def main_flow
        empty_directory "app/controll"
        inside "app/controll" do
          create_folders.each do |folder|
            empty_directory folder
          end
        end
      end

      protected

      def create_folders
        return mapper_folders unless folders.empty?
        valid_folders
      end

      def mapper_folders
        @mapper_folders ||= folders.map {|f| f.to_s.underscore }.select{|f| valid_artifact? f }
      end

      def valid_folder? folder
        valid_folders.include? folder.to_s.underscore
      end

      def valid_folders
        %w{executors flow_handlers notifiers commanders assistants}
      end
    end
  end
end