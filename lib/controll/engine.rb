module Controll
  module Rails
    class Engine < ::Rails::Engine
      initializer 'setup controll' do
        config.autoload_paths += Dir[Rails.root.join('app', 'controll')]
      end
    end
  end
end
