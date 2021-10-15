# frozen_string_literal: true

class UsersController < ApplicationController
  before_action :authorize_access_request!, except: :create

  def show
    render_json_response(data: current_user, serializer: UserSerializer)
  end

  def create
    response = Actions::Users::CreateUser.new(permitted_create_params).call

    if response.success?
      render_json_response(data: response.payload, serializer: UserSerializer)
    else
      render_json_error1(response.error)
    end
  end

  def update
    response = Actions::Users::UpdateUser.new(current_user, permitted_update_params).call

    if response.success?
      render_json_response(data: response.payload, serializer: UserSerializer)
    else
      render_json_error1(response.error)
    end
  end

  private

  def permitted_create_params
    params.permit(:name, :surname, :email, :password, :password_confirmation).to_h
  end

  def permitted_update_params
    params.permit(:name, :surname, :email, :current_password, :new_password, :new_password_confirmation).to_h
  end
end
