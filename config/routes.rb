Rails.application.routes.draw do
  
  resources :teams
  resources :groups
  resources :games
  root 'game_turnaments#index'

  resources :game_turnaments do 
    member do 
      get :group_game  
      get :play_off  
      get :final
      get :matches
    end
  end
  

  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
end
