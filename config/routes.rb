Rails.application.routes.draw do

  resources :workers, only: [:create, :update, :show, :index, :destroy] do
    resources :shifts, only: [:create, :update, :show, :index, :destroy]
  end

  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
end
