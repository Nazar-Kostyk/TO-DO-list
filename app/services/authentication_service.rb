# frozen_string_literal: true

class AuthenticationService < BaseService
  attr_reader :params

  def initialize(params)
    @params = params
  end

  def call
    return build_unauthorized_request_error unless user.authenticate(params[:password])

    session = JWTSessions::Session.new(payload: { user_id: user.id })

    build_success_response(session.login)
  end

  private

  def user
    @user ||= User.find_by!(email: params[:email])
  end

  def build_unauthorized_request_error
    build_failure_response(
      {
        status: :unauthorized,
        details: error_details_by_translation_key('bad_credentials')
      }
    )
  end
end
