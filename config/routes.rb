# frozen_string_literal: true

Rails.application.routes.draw do
  root 'health_check#health'

  resource :user, only: %i[show create update]
  resources :to_do_lists do
    resources :tasks do
      patch :change_position, on: :member
    end
  end

  resource :sessions, only: :create
end
