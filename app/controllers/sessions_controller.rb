# frozen_string_literal: true

class SessionsController < ApplicationController
  def create
    result = AuthenticationService.new(permitted_create_params).call

    render json: result.payload
  end

  private

  def permitted_create_params
    params.permit(:email, :password)
  end
end
