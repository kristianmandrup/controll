ControllApp::Application.routes.draw do
  focused_controller_routes do
    resources :services
  end
end
