# frozen_string_literal: true

class SessionsController < ApplicationController
  def create
    response = AuthenticationService.new(permitted_create_params).call

    if response.success?
      render json: response.payload
    else
      render_json_error1(response.error)
    end
  end

  private

  def permitted_create_params
    params.permit(:email, :password)
  end
end
