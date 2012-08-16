module Controll
  class SetupGenerator < Rails::Generator::Base
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
      return folders unless folders.empty? 
      %w{executors flow_handlers notifiers commanders}
    end
  end
end