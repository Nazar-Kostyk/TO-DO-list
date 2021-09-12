# frozen_string_literal: true

class UsersController < ApplicationController
  def create
    validator = Users::Create::CreateParamsValidator.new.call(permitted_create_params)

    render json: validator.errors.to_h if validator.failure?
  end

  private

  def permitted_create_params
    params.permit(:name, :surname, :email, :password).to_h
  end
end
