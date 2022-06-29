# frozen_string_literal: true

class AuthenticationService < BaseService
  attr_reader :params

  def initialize(params)
    @params = params
  end

  def call
    return unauthorized_request unless correct_password_provdided?

    session = JWTSessions::Session.new(payload: { user_id: user.id })

    build_success_response(session.login)
  end

  private

  def user
    @user ||= User.find_by!(email: params[:email])
  end

  def correct_password_provdided?
    user.authenticate(params[:password])
  end

  def unauthorized_request
    build_failure_response(
      {
        status: :unauthorized,
        details: error_details_by_translation_key('bad_credentials')
      }
    )
  end
end
