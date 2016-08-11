Rails.application.routes.draw do
  namespace :admin do
    resources :users
    root to: "users#index"
  end
  root to: 'visitors#index'
  devise_for :users
  resources :users
  get '/charts/line' => 'charts#line'
  post 'charts/display_line' => 'charts#display_line', :defaults => { :format => 'js' }
  get '/charts/bar' => 'charts#bar'
  post 'charts/display_bar' => 'charts#display_bar', :defaults => { :format => 'js' }
  get '/charts/pie' => 'charts#pie'
  post 'charts/display_pie' => 'charts#display_pie', :defaults => { :format => 'js' }
  get '/charts/zipf' => 'charts#zipf'
  post 'charts/display_zipf' => 'charts#display_zipf', :defaults => { :format => 'js' }
end
