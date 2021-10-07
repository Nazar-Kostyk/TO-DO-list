# frozen_string_literal: true

class AuthenticationService
  attr_reader :params

  def initialize(params)
    @params = params
  end

  def call
    user = User.find_by!(email: params[:email])
    if user.authenticate(params[:password])
      payload = { user_id: user.id }
      session = JWTSessions::Session.new(payload: payload)

      OpenStruct.new({ success?: true, payload: session.login })
    else
      OpenStruct.new({ success?: false, error: { status: :unauthorized, error_key: 'bad_credentials' } })
    end
  end
end
