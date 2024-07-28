Rails.application.routes.draw do
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html
  devise_for :users,
  controllers: {
    sessions: 'users/sessions',
    registrations: 'users/registrations'
  }

  devise_scope :user do
    post 'login', to: 'users/sessions#create'
    delete 'logout', to: 'users/sessions#destroy'
    post 'signup', to: 'users/registrations#create'
  end

  resources :pets, only: [:create, :index, :update] do
    collection do
      get :outside_zone_statistics
    end
  end
end
