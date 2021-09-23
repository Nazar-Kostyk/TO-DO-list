# frozen_string_literal: true

class UsersController < ApplicationController
  before_action :authorize_request, except: :create

  def create
    validator = Users::Create::CreateParamsValidator.new.call(permitted_create_params)

    if validator.success?
      @user = User.new(permitted_create_params.slice(:name, :surname, :email, :password))
      if @user.save
        render_response(user: @user, status: :created)
      else
        render json: { errorDetails: I18n.t('messages.database_error') }, status: :unprocessable_entity
      end
    else
      render_json_validation_error(validator.errors.to_h)
    end
  end

  def update
    validator = Users::Update::UpdateParamsValidator.new.call(permitted_update_params)

    if validator.success?
      unless correct_password_provdided?
        return render json: { errorDetails: I18n.t('messages.wrong_password') },
                      status: :bad_request
      end

      if @current_user.update(map_request_params_to_model_params)
        render_response(user: @current_user, status: :ok)
      else
        render json: { errorDetails: I18n.t('messages.database_error') }, status: :unprocessable_entity
      end
    else
      render_json_validation_error(validator.errors.to_h)
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

    request_params.slice(:name, :surname, :email)
                  .merge({ password: request_params[:new_password] })
                  .compact
  end

  def render_response(user:, status: :ok)
    render json: UserSerializer.new(user).serializable_hash, status: status
  end

  def render_json_validation_error(errors_hash)
    errors =
      errors_hash.map do |attribute_name, error_details|
        error_details.map do |detail|
          {
            source: {
              pointer: "/data/attributes/#{attribute_name}"
            },
            title: 'Invalid Attribute',
            detail: detail
          }
        end
      end.flatten

    render json: { errors: errors }, status: :bad_request
  end
end
