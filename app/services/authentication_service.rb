# frozen_string_literal: true

class AuthenticationService < BaseService
  attr_reader :params

  def initialize(params)
    @params = params
  end

  def call
    return validation_errors if validator.failure?
    return unauthorized_request unless correct_password_provdided?

    session = JWTSessions::Session.new(payload: { user_id: user.id })

    build_success_response(session.login)
  end

  private

  def user
    @user ||= User.find_by!(email: params[:email])
  end

  def validator
    @validator ||= ::Sessions::CreateParamsValidator.new.call(params)
  end

  def validation_errors
    build_validation_errors_response(validator.errors.to_h)
  end

  def correct_password_provdided?
    user.authenticate(params[:password])
  end

  def unauthorized_request
    build_error_response_by_translation_key(status: :unauthorized, translation_key: 'wrong_password')
  end
end
