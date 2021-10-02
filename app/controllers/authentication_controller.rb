# frozen_string_literal: true

class AuthenticationController < ApplicationController
  before_action :authorize_request, except: :login

  def login
    @user = User.find_by(email: login_params[:email])
    if @user&.authenticate(login_params[:password])
      token = JsonWebToken.encode(user_id: @user.id)
      time_to_expiration = 24.hours.to_i

      render_json_response(token, time_to_expiration)
    else
      render_json_error(status: :unauthorized, error_key: 'bad_credentials')
    end
  end

  private

  def login_params
    params.permit(:email, :password)
  end

  def render_json_response(token, exp)
    response_body =
      {
        access_token: token,
        token_type: 'Authorization',
        expires_in: exp
      }

    render json: response_body, status: :ok
  end
end
