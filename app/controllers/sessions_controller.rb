# frozen_string_literal: true

class SessionsController < ApplicationController
  def create
    result = AuthenticationService.new(permitted_create_params).call

    if result.success?
      render json: result.payload
    else
      render_json_error(status: result.error[:status], error_key: result.error[:error_key])
    end
  end

  private

  def permitted_create_params
    params.permit(:email, :password)
  end
end
