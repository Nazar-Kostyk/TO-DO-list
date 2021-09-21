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
    validator = Users::Update::UpdateParamsValidator.new.call(permitted_update_params)

    if validator.success?
        return render json: { errorDetails: 'Wrong password entered.' } unless correct_password_provdided?

        if @current_user.update(map_request_params_to_model_params)
        render json: @user, status: :updated
      else
        render json: { errorDetails: 'Database error occurred.' }, status: :unprocessable_entity
      end
    else
      render json: validator.errors.to_h
    end
  end

  private

  def permitted_create_params
    params.permit(:name, :surname, :email, :password, :password_confirmation).to_h
  end

  def permitted_update_params
    params.permit(:name, :surname, :email, :current_password, :new_password, :new_password_confirmation).to_h
  end

  def correct_password_provdided?
    @current_user.authenticate(permitted_update_params[:current_password])
  end

  def map_request_params_to_model_params
    request_params = permitted_update_params

    request_params.slice(:name, :surname, :email).merge({password: request_params[:new_password]}).compact
  end
end
