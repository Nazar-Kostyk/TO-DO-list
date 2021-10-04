# frozen_string_literal: true

Rails.application.routes.draw do
  root 'health_check#health'

  resource :user, only: %i[show create update]
  resources :to_do_lists do
    resources :tasks, only: %i[show create update destroy]
  end

  post 'auth/login', to: 'authentication#login'
end
