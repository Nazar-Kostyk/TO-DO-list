# frozen_string_literal: true

Rails.application.routes.draw do
  root 'health_check#health'

  resource :user, only: %i[show create update]
  resources :to_do_lists

  post 'auth/login', to: 'authentication#login'
end
