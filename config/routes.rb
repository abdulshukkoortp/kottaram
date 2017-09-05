Rails.application.routes.draw do
  root 'home#index'
  devise_for :users, controllers: {
    omniauth_callbacks: 'omniauth_callbacks'
  }

  resources :users, only: [:show] do
    member do
      put 'change_payment_status'
    end
  end

  resources :events, only: [:index] do
  	member do
  	  put 'generate_group'
  	end
    resources :groups, only: [:show] do
      member do
        put 'completed'
        put 'skipped'
      end
    end
  end

  resources :splitwises do
    collection do
      get 'analysis'
    end
  end

  resources :penalties do
    member do
      get 'approve'
    end
  end
end
