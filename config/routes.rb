# frozen_string_literal: true

Rails.application.routes.draw do
  root 'health_check#health'

  resource :user
end
