# frozen_string_literal: true

class ApplicationController < ActionController::API
  include JWTSessions::RailsAuthorization
  include Builders::ErrorBuilder

  rescue_from JWTSessions::Errors::Unauthorized, with: :not_authorized
  rescue_from ActiveRecord::RecordNotFound, with: :not_found

  def current_user
    @current_user ||= User.find(payload['user_id'])
  end

  def render_json_response(data:, serializer:, options: {}, status: :ok)
    render json: serializer.new(data, options).serializable_hash, status: status
  end

  def not_found(exception)
    error =
      build_error_by_translation_key(
        status: :not_found,
        translation_key: "#{exception.model.underscore}_not_found"
      )

    render_json_error(error)
  end

  def not_authorized
    error =
      build_error_by_translation_key(
        status: :unauthorized,
        translation_key: 'unauthorized_request'
      )

    render_json_error(error)
  end

  def render_json_error(error)
    render json: { errors: Array.wrap(error[:details]) }, status: error[:status]
  end
end
