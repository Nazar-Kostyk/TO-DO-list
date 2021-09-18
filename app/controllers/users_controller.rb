# frozen_string_literal: true

class UsersController < ApplicationController
  before_action :authorize_request, except: :create

  def create
    validator = Users::Create::CreateParamsValidator.new.call(permitted_create_params)

    if validator.success?
      @user = User.new(permitted_create_params.slice(:name, :surname, :email, :password))
      if @user.save
        render json: @user, status: :created
      else
        render json: { errorDetails: 'Database error occurred.' }, status: :unprocessable_entity
      end
    else
      render json: validator.errors.to_h
    end
  end

  def update
    # TODO: implement update user feature
    # permitted_update_params: :name, :surname, :email, :old_password, :new_password, :password_confirmation
  end

  private

  def permitted_create_params
    params.permit(:name, :surname, :email, :password, :password_confirmation).to_h
  end
end
